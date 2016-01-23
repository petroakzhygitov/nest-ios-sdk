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
#import <NestSDK/NestSDKMetadataDataModel.h>
#import <NestSDK/NestSDKApplicationDelegate.h>
#import <NestSDK/NestSDKError.h>
#import <NestSDK/NestSDKStructureDataModel.h>
#import <NestSDK/NestSDKThermostatDataModel.h>
#import <NestSDK/NestSDKSmokeCOAlarmDataModel.h>
#import <NestSDK/NestSDKCameraDataModel.h>

#pragma mark const

static NSString *const kEndpointPathRoot = @"/";
static NSString *const kEndpointPathStructures = @"structures/";
static NSString *const kEndpointPathDevices = @"devices/";
static NSString *const kEndpointPathThermostats = @"thermostats/";
static NSString *const kEndpointPathSmokeCOAlarms = @"smoke_co_alarms/";
static NSString *const kEndpointPathCameras = @"cameras/";

#pragma mark typedef

typedef void (^NestSDKDataUpdateHandler)(id, NSError *);

@interface NestSDKDataManager ()

@property(nonatomic, readonly) id <NestSDKService> service;

@end


@implementation NestSDKDataManager
#pragma mark Private

- (NSString *)_rootURL {
    return kEndpointPathRoot;
}

- (NSString *)_structuresURL {
    return kEndpointPathStructures;
}

- (NSString *)_structureURLWithStructureId:(NSString *)structureId {
    return [NSString stringWithFormat:@"%@%@/", kEndpointPathStructures, structureId];
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

- (NSError *)_parseErrorWithUnderlyingError:(NSError *)error {
    return error ? [NestSDKError unableToParseDataErrorWithUnderlyingError:error] : nil;
}

- (NSError *)_errorInResult:(id)result orError:(NSError *)error {
    if (error) return error;

    if (![result isKindOfClass:[NSDictionary class]]) {
        return [NestSDKError unexpectedArgumentTypeErrorWithName:@"result" message:nil];
    }

    return nil;
}

- (NSArray *)_dataModelsArrayWithClass:(Class)dataModelClass result:(id)result error:(NSError **)error {
    NSDictionary *resultDictionary = (NSDictionary *) result;
    NSMutableArray *dataModelsArray = [[NSMutableArray alloc] initWithCapacity:resultDictionary.count];

    for (NSDictionary *dictionary in resultDictionary.allValues) {
        id dataModelInArray = [(JSONModel *) [dataModelClass alloc] initWithDictionary:dictionary error:error];
        if ((*error)) return nil;

        [dataModelsArray addObject:dataModelInArray];
    }

    return dataModelsArray;
}

- (NestSDKDataModel *)_dataModelWithClass:(Class)dataModelClass result:(id)result error:(NSError **)error {
    return [(NestSDKDataModel *) [dataModelClass alloc] initWithDictionary:result error:error];
}

- (void)_executeBlock:(NestSDKDataUpdateHandler)block withDataModel:(id)dataModel parseError:(NSError *)parseError {
    NSError *error = [self _parseErrorWithUnderlyingError:parseError];

    [self _executeBlock:block withDataModel:dataModel error:error];
}

- (void)_executeBlock:(NestSDKDataUpdateHandler)block withDataModel:(id)dataModel error:(NSError *)error {
    if (error) {
        block(nil, error);

    } else {
        block(dataModel, nil);
    }
}

- (void)_dataModelFromURL:(NSString *)url withClass:(Class)dataModelClass block:(NestSDKDataUpdateHandler)block {
    [self _dataModelFromURL:url withClass:dataModelClass block:block asArray:NO];
}

- (void)_dataModelFromURL:(NSString *)url withClass:(Class)dataModelClass
                    block:(NestSDKDataUpdateHandler)block asArray:(BOOL)asArray {

    __weak typeof(self) weakSelf = self;
    [self.service valuesForURL:url withBlock:^(id result, NSError *error) {
        typeof(self) self = weakSelf;
        if (!self) return;

        [self _handleResultWithDataModelClass:dataModelClass block:block result:result error:error asArray:asArray];
    }];
}

- (void)_setDataModel:(id <NestSDKDataModelProtocol>)dataModel forURL:(NSString *)url block:(NestSDKDataUpdateHandler)block {
    NestSDKDataModel *currentDataModel = (NestSDKDataModel *) dataModel;

    __weak typeof(self) weakSelf = self;
    [self.service setValues:[currentDataModel toWritableDataModelDictionary] forURL:url withBlock:^(id result, NSError *error) {
        typeof(self) self = weakSelf;
        if (!self) return;

        [self _handleResultWithDataModelClass:[currentDataModel class] block:block result:result error:error asArray:NO];
    }];
}

- (NestSDKObserverHandle)_observeDataModelWithURL:(NSString *)url withClass:(Class)dataModelClass
                                            block:(NestSDKDataUpdateHandler)block {

    return [self _observeDataModelWithURL:url withClass:dataModelClass block:block asArray:NO];
}

- (NestSDKObserverHandle)_observeDataModelWithURL:(NSString *)url withClass:(Class)dataModelClass
                                            block:(NestSDKDataUpdateHandler)block asArray:(BOOL)asArray {

    __weak typeof(self) weakSelf = self;
    return [self.service observeValuesForURL:url withBlock:^(id result, NSError *error) {
        typeof(self) self = weakSelf;
        if (!self) return;

        [self _handleResultWithDataModelClass:dataModelClass block:block result:result error:error asArray:asArray];
    }];
}

- (void)_handleResultWithDataModelClass:(Class)dataModelClass block:(NestSDKDataUpdateHandler)block
                                 result:(id)result error:(NSError *)error asArray:(BOOL)asArray {

    NSError *resultError = [self _errorInResult:result orError:error];
    if (resultError) {
        [self _executeBlock:block withDataModel:nil error:resultError];

        return;
    }

    id dataModel;
    NSError *parseError;

    // In case we need array of models, like for example for structures
    if (asArray) {
        dataModel = [self _dataModelsArrayWithClass:dataModelClass result:result error:&parseError];

    } else {
        // In case there is only one model needed
        dataModel = [self _dataModelWithClass:dataModelClass result:result error:&parseError];
    }

    [self _executeBlock:block withDataModel:dataModel parseError:parseError];
}

#pragma mark Override

- (id <NestSDKService>)service {
    return [NestSDKApplicationDelegate service];
}

#pragma mark Public

- (void)metadataWithBlock:(NestSDKMetadataUpdateHandler)block {
    [self _dataModelFromURL:[self _rootURL]
                  withClass:[NestSDKMetadataDataModel class]
                      block:block];
}

- (void)structuresWithBlock:(NestSDKStructuresArrayUpdateHandler)block {
    [self _dataModelFromURL:[self _structuresURL]
                  withClass:[NestSDKStructureDataModel class]
                      block:block
                    asArray:YES];
}

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresArrayUpdateHandler)block {
    return [self _observeDataModelWithURL:[self _structuresURL]
                                withClass:[NestSDKStructureDataModel class]
                                    block:block
                                  asArray:YES];
}

- (void)setStructure:(id <NestSDKStructure>)structure block:(NestSDKStructureUpdateHandler)block {
    [self _setDataModel:structure
                 forURL:[self _structureURLWithStructureId:structure.structureId]
                  block:block];
}


- (void)thermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block {
    [self _dataModelFromURL:[self _thermostatURLWithThermostatId:thermostatId]
                  withClass:[NestSDKThermostatDataModel class]
                      block:block];
}

- (NestSDKObserverHandle)observeThermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block {
    return [self _observeDataModelWithURL:[self _thermostatURLWithThermostatId:thermostatId]
                                withClass:[NestSDKThermostatDataModel class]
                                    block:block];
}

- (void)setThermostat:(id <NestSDKThermostat>)thermostat block:(NestSDKThermostatUpdateHandler)block {
    [self _setDataModel:thermostat
                 forURL:[self _thermostatURLWithThermostatId:thermostat.deviceId]
                  block:block];
}

- (void)smokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block {
    [self _dataModelFromURL:[self _smokeCOAlarmURLWithSmokeCOAlarmId:smokeCOAlarmId]
                  withClass:[NestSDKSmokeCOAlarmDataModel class]
                      block:block];
}

- (NestSDKObserverHandle)observeSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block {
    return [self _observeDataModelWithURL:[self _smokeCOAlarmURLWithSmokeCOAlarmId:smokeCOAlarmId]
                                withClass:[NestSDKSmokeCOAlarmDataModel class]
                                    block:block];
}

- (void)setSmokeCOAlarm:(NestSDKSmokeCOAlarmDataModel *)smokeCOAlarm block:(NestSDKSmokeCOAlarmUpdateHandler)block {
    [self _setDataModel:smokeCOAlarm
                 forURL:[self _smokeCOAlarmURLWithSmokeCOAlarmId:smokeCOAlarm.deviceId]
                  block:block];
}

- (void)cameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block {
    [self _dataModelFromURL:[self _cameraURLWithCameraId:cameraId]
                  withClass:[NestSDKCameraDataModel class]
                      block:block];
}

- (void)setCamera:(NestSDKCameraDataModel *)camera block:(NestSDKCameraUpdateHandler)block {
    [self _setDataModel:camera
                 forURL:[self _cameraURLWithCameraId:camera.deviceId]
                  block:block];
}

- (NestSDKObserverHandle)observeCameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block {
    return [self _observeDataModelWithURL:[self _cameraURLWithCameraId:cameraId]
                                withClass:[NestSDKCameraDataModel class]
                                    block:block];
}

- (void)removeObserverWithHandle:(NestSDKObserverHandle)handle {
    [self.service removeObserverWithHandle:handle];
}

- (void)removeAllObservers {
    [self.service removeAllObservers];
}

@end