// Copyright (c) 2016 Petro Akzhygitov <petro.akzhygitov@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <JSONModel/JSONModel.h>
#import <NestSDK/NestSDKDataManager.h>
#import <NestSDK/NestSDKMetadata.h>
#import <NestSDK/NestSDKApplicationDelegate.h>
#import <NestSDK/NestSDKError.h>
#import <NestSDK/NestSDKStructure.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import <NestSDK/NestSDKCamera.h>


#pragma mark const

static NSString *const kEndpointPathRoot = @"/";
static NSString *const kEndpointPathStructures = @"structures/";
static NSString *const kEndpointPathDevices = @"devices/";
static NSString *const kEndpointPathThermostats = @"thermostats/";
static NSString *const kEndpointPathSmokeCOAlarms = @"smoke_co_alarms/";
static NSString *const kEndpointPathCameras = @"cameras/";

#pragma mark typedef

typedef void (^NestSDKDataModelUpdateHandler)(id, NSError *);

@interface NestSDKDataManager ()

@property(nonatomic) id <NestSDKService> service;

@end


@implementation NestSDKDataManager
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

@end