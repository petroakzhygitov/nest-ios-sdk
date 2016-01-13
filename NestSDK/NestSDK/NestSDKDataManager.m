#import <JSONModel/JSONModel.h>
#import <NestSDK/NestSDKDataManager.h>
#import <NestSDK/NestSDKMetadata.h>
#import <NestSDK/NestSDKApplicationDelegate.h>
#import <NestSDK/NestSDKError.h>
#import <NestSDK/NestSDKStructure.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import <NestSDK/NestSDKCamera.h>

#pragma mark macros
#pragma mark const

static NSString *const kEndpointPathRoot = @"/";
static NSString *const kEndpointPathStructures = @"structures/";
static NSString *const kEndpointPathDevices = @"devices/";
static NSString *const kEndpointPathThermostats = @"thermostats/";
static NSString *const kEndpointPathSmokeCOAlarms = @"smoke_co_alarms/";
static NSString *const kEndpointPathCameras = @"cameras/";

#pragma mark enum

#pragma mark typedef

typedef void (^NestSDKDataModelUpdateHandler)(id, NSError *);

@interface NestSDKDataManager ()

@property(nonatomic) id <NestSDKService> service;

@end


@implementation NestSDKDataManager {
#pragma mark Instance variables
}

#pragma mark Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.service = [NestSDKApplicationDelegate service];
    }

    return self;
}

#pragma mark Private

- (NSString *)_rootURL {
    return kEndpointPathRoot;
}

- (NSString *)_structuresURL {
    return kEndpointPathStructures;
}

- (NSString *)_thermostatURLWithThermostatId:(NSString *)thermostatId {
    return [NSString stringWithFormat:@"%@%@%@/", kEndpointPathDevices, kEndpointPathThermostats, thermostatId];
}

- (NSString *)_smokeCOAlarmURLWithSmokeCOAlarmId:(NSString *)smokeCOAlarmId {
    return [NSString stringWithFormat:@"%@%@%@/", kEndpointPathDevices, kEndpointPathSmokeCOAlarms, smokeCOAlarmId];
}

- (NSString *)_cameraURLWithCameraId:(NSString *)cameraId {
    return [NSString stringWithFormat:@"%@%@%@/", kEndpointPathDevices, kEndpointPathCameras, cameraId];
}

- (void)_dataModelFromURL:(NSString *)url withClass:(Class)dataModelClass block:(NestSDKDataModelUpdateHandler)block {
    [self _dataModelFromURL:url withClass:dataModelClass block:block asArray:NO];
}

- (void)_dataModelFromURL:(NSString *)url withClass:(Class)dataModelClass
                    block:(NestSDKDataModelUpdateHandler)block asArray:(BOOL)asArray {

    [self.service valuesForURL:url withBlock:^(id result, NSError *error) {
        [self _handleResultWithDataModelClass:dataModelClass block:block result:result error:error asArray:asArray];
    }];
}

- (NestSDKObserverHandle)_observeDataModelWithURL:(NSString *)url withClass:(Class)dataModelClass
                                            block:(NestSDKDataModelUpdateHandler)block {

    return [self _observeDataModelWithURL:url withClass:dataModelClass block:block asArray:NO];
}

- (NestSDKObserverHandle)_observeDataModelWithURL:(NSString *)url withClass:(Class)dataModelClass
                                            block:(NestSDKDataModelUpdateHandler)block asArray:(BOOL)asArray {

    return [self.service observeValuesForURL:url withBlock:^(id result, NSError *error) {
        [self _handleResultWithDataModelClass:dataModelClass block:block result:result error:error asArray:asArray];
    }];
}

- (void)_handleResultWithDataModelClass:(Class)dataModelClass block:(NestSDKDataModelUpdateHandler)block
                                 result:(id)result error:(NSError *)error asArray:(BOOL)asArray {
    if (error) {
        block(nil, error);
        return;
    }

    if (![result isKindOfClass:[NSDictionary class]]) {
        block(nil, [NestSDKError unexpectedArgumentTypeErrorWithName:@"result" message:nil]);
        return;
    }

    id dataModel;

    // In case we need array of models, like for example for structures
    if (asArray) {
        NSDictionary *resultDictionary = (NSDictionary *) result;
        NSMutableArray *dataModelsArray = [[NSMutableArray alloc] initWithCapacity:resultDictionary.count];

        for (NSDictionary *dictionary in resultDictionary.allValues) {
            id dataModelInArray = [(JSONModel *) [dataModelClass alloc] initWithDictionary:dictionary error:&error];
            if (error) break;

            [dataModelsArray addObject:dataModelInArray];
        }

        dataModel = dataModelsArray;

    } else {
        // In case there is only one model needed
        dataModel = [(JSONModel *) [dataModelClass alloc] initWithDictionary:result error:&error];
    }

    if (error) {
        block(nil, [NestSDKError unableToParseDataErrorWithUnderlyingError:error]);
    }

    block(dataModel, nil);
}

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

- (void)metadataWithBlock:(NestSDKMetadataUpdateHandler)block {
    [self _dataModelFromURL:[self _rootURL]
                  withClass:[NestSDKMetadata class]
                      block:block];
}

- (void)structuresWithBlock:(NestSDKStructuresUpdateHandler)block {
    [self _dataModelFromURL:[self _structuresURL]
                  withClass:[NestSDKStructure class]
                      block:block
                    asArray:YES];
}

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresUpdateHandler)block {
    return [self _observeDataModelWithURL:[self _structuresURL]
                                withClass:[NestSDKStructure class]
                                    block:block
                                  asArray:YES];
}

- (void)thermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block {
    [self _dataModelFromURL:[self _thermostatURLWithThermostatId:thermostatId]
                  withClass:[NestSDKThermostat class]
                      block:block];
}

- (void)setThermostat:(NestSDKThermostat *)thermostat block:(NestSDKThermostatUpdateHandler)block {

}

- (void)smokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKThermostatUpdateHandler)block {
    [self _dataModelFromURL:[self _smokeCOAlarmURLWithSmokeCOAlarmId:smokeCOAlarmId]
                  withClass:[NestSDKSmokeCOAlarm class]
                      block:block];
}

- (void)setSmokeCOAlarm:(NestSDKSmokeCOAlarm *)smokeCOAlarm block:(NestSDKThermostatUpdateHandler)block {

}

- (void)cameraWithId:(NSString *)cameraId block:(NestSDKThermostatUpdateHandler)block {
    [self _dataModelFromURL:[self _cameraURLWithCameraId:cameraId]
                  withClass:[NestSDKCamera class]
                      block:block];
}

- (void)setCamera:(NestSDKCamera *)camera block:(NestSDKThermostatUpdateHandler)block {

}

- (NestSDKObserverHandle)observeThermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block {
    return [self _observeDataModelWithURL:[self _structuresURL]
                                withClass:[NestSDKThermostat class]
                                    block:block];
}

- (NestSDKObserverHandle)observeSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block {
    return [self _observeDataModelWithURL:[self _structuresURL]
                                withClass:[NestSDKSmokeCOAlarm class]
                                    block:block];
}

- (NestSDKObserverHandle)observeCameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block {
    return [self _observeDataModelWithURL:[self _structuresURL]
                                withClass:[NestSDKCamera class]
                                    block:block];
}

- (void)removeObserverWithHandle:(NestSDKObserverHandle)handle {
    [self.service removeObserverWithHandle:handle];
}

- (void)removeAllObservers {
    [self.service removeAllObservers];
}


#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end