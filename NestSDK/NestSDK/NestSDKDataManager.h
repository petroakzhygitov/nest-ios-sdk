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
#import <NestSDK/NestSDKService.h>

@protocol NestSDKStructure;
@protocol NestSDKThermostat;
@protocol NestSDKMetadata;
@protocol NestSDKSmokeCOAlarm;
@protocol NestSDKCamera;


#pragma mark typedef

typedef void (^NestSDKStructureUpdateHandler)(id <NestSDKStructure> structure, NSError *);

typedef void (^NestSDKStructuresArrayUpdateHandler)(NSArray <NestSDKStructure> *structuresArray, NSError *);

typedef void (^NestSDKMetadataUpdateHandler)(id <NestSDKMetadata> metadata, NSError *);

typedef void (^NestSDKThermostatUpdateHandler)(id <NestSDKThermostat> thermostat, NSError *);

typedef void (^NestSDKSmokeCOAlarmUpdateHandler)(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *);

typedef void (^NestSDKCameraUpdateHandler)(id <NestSDKCamera> camera, NSError *);


@interface NestSDKDataManager : NSObject
#pragma mark Methods

- (void)metadataWithBlock:(NestSDKMetadataUpdateHandler)block;


- (void)structuresWithBlock:(NestSDKStructuresArrayUpdateHandler)block;

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresArrayUpdateHandler)block;

- (void)setStructure:(id <NestSDKStructure>)structure block:(NestSDKStructureUpdateHandler)block;


- (void)thermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (NestSDKObserverHandle)observeThermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (void)setThermostat:(id <NestSDKThermostat>)thermostat block:(NestSDKThermostatUpdateHandler)block;


- (void)smokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block;

- (NestSDKObserverHandle)observeSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block;


- (void)cameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block;

- (NestSDKObserverHandle)observeCameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block;

- (void)setCamera:(id <NestSDKCamera>)camera block:(NestSDKCameraUpdateHandler)block;


- (void)removeObserverWithHandle:(NestSDKObserverHandle)handle;

- (void)removeAllObservers;


@end