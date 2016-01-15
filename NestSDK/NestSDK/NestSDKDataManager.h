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

#import <Foundation/Foundation.h>
#import "NestSDKService.h"

@class NestSDKMetadataDataModel;
@class NestSDKSmokeCOAlarmDataModel;
@class NestSDKCameraDataModel;
@protocol NestSDKDataModel;
@protocol NestSDKStructure;
@protocol NestSDKThermostat;


#pragma mark typedef

typedef void (^NestSDKDataUpdateHandler)(id, NSError *);

typedef void (^NestSDKStructuresUpdateHandler)(NSArray <NestSDKStructure> *structuresArray, NSError *);

typedef void (^NestSDKMetadataUpdateHandler)(NestSDKMetadataDataModel *, NSError *);

typedef void (^NestSDKThermostatUpdateHandler)(id <NestSDKThermostat>, NSError *);

typedef void (^NestSDKSmokeCOAlarmUpdateHandler)(NestSDKSmokeCOAlarmDataModel *, NSError *);

typedef void (^NestSDKCameraUpdateHandler)(NestSDKCameraDataModel *, NSError *);


@interface NestSDKDataManager : NSObject
#pragma mark Methods

- (void)metadataWithBlock:(NestSDKMetadataUpdateHandler)block;


- (void)structuresWithBlock:(NestSDKStructuresUpdateHandler)block;

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresUpdateHandler)block;


- (void)thermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (void)setThermostat:(id <NestSDKThermostat>)thermostat block:(NestSDKThermostatUpdateHandler)block;


- (void)smokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block;

- (void)setSmokeCOAlarm:(NestSDKSmokeCOAlarmDataModel *)smokeCOAlarm block:(NestSDKSmokeCOAlarmUpdateHandler)block;


- (void)cameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block;

- (void)setCamera:(NestSDKCameraDataModel *)camera block:(NestSDKCameraUpdateHandler)block;


- (NestSDKObserverHandle)observeThermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (NestSDKObserverHandle)observeSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block;

- (NestSDKObserverHandle)observeCameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block;


- (void)removeObserverWithHandle:(NestSDKObserverHandle)handle;

- (void)removeAllObservers;


@end