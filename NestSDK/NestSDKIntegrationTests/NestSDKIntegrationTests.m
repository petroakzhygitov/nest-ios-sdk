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

#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "LSStubRequestDSL.h"
#import "LSNocilla.h"
#import "NestSDKApplicationDelegate.h"
#import "NestSDKAccessToken.h"
#import "NestSDKDataManager.h"
#import "JSONModel.h"
#import "NestSDKStructureDataModel.h"
#import "NestSDKThermostatDataModel.h"
#import "NestSDKSmokeCOAlarmDataModel.h"
#import "NestSDKcameraDataModel.h"


SpecBegin(NestSDKIntegration)
    {
        describe(@"NestSDKIntegration", ^{

            __block NestSDKStructureDataModel *originalTestHomeStructure;
            __block NestSDKStructureDataModel *originalAnotherTestHomeStructure;

            __block NestSDKThermostatDataModel *originalThermostat;
            __block NestSDKSmokeCOAlarmDataModel *originalSmokeCOAlarm;
            __block NestSDKCameraDataModel *originalCamera;

            beforeAll(^{
                [[NestSDKApplicationDelegate sharedInstance] application:nil didFinishLaunchingWithOptions:nil];

                NSString *accessTokenString = [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"NestSDKAccessToken"];
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:accessTokenString expirationDate:[NSDate distantFuture]];

                [NestSDKAccessToken setCurrentAccessToken:accessToken];


                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;

                NSString *testHomeStructureDataPath = [resourcePath stringByAppendingPathComponent:@"test-home-structure-data.json"];
                NSString *anotherTestHomeStructureDataPath = [resourcePath stringByAppendingPathComponent:@"another-test-home-structure-data.json"];
                NSString *thermostatDataPath = [resourcePath stringByAppendingPathComponent:@"thermostat-data.json"];
                NSString *smokeCOAlarmDataPath = [resourcePath stringByAppendingPathComponent:@"smoke-co-alarm-data.json"];
                NSString *cameraDataPath = [resourcePath stringByAppendingPathComponent:@"camera-data.json"];

                NSData *testHomeStructureData = [NSData dataWithContentsOfFile:testHomeStructureDataPath];
                NSData *anotherTestHomeStructureData = [NSData dataWithContentsOfFile:anotherTestHomeStructureDataPath];
                NSData *thermostatData = [NSData dataWithContentsOfFile:thermostatDataPath];
                NSData *smokeCOAlarmData = [NSData dataWithContentsOfFile:smokeCOAlarmDataPath];
                NSData *cameraData = [NSData dataWithContentsOfFile:cameraDataPath];

                NSError *error;
                originalTestHomeStructure = [[NestSDKStructureDataModel alloc] initWithData:testHomeStructureData error:&error];
                expect(error).to.equal(nil);

                originalAnotherTestHomeStructure = [[NestSDKStructureDataModel alloc] initWithData:anotherTestHomeStructureData error:&error];
                expect(error).to.equal(nil);

                originalThermostat = [[NestSDKThermostatDataModel alloc] initWithData:thermostatData error:&error];
                expect(error).to.equal(nil);

                originalSmokeCOAlarm = [[NestSDKSmokeCOAlarmDataModel alloc] initWithData:smokeCOAlarmData error:&error];
                expect(error).to.equal(nil);

                originalCamera = [[NestSDKCameraDataModel alloc] initWithData:cameraData error:&error];
                expect(error).to.equal(nil);
            });

            it(@"should observe structures", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __block NestSDKObserverHandle handle = [dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                        expect(error).to.equal(nil);

                        id <NestSDKStructure> anotherTestHomeStructure = structuresArray.firstObject;
                        id <NestSDKStructure> testHomeStructure = structuresArray.lastObject;

                        if (![testHomeStructure.name isEqual:@"Test Home"]) {
                            testHomeStructure = structuresArray.firstObject;
                            anotherTestHomeStructure = structuresArray.lastObject;
                        }

                        expect(testHomeStructure).to.equal(originalTestHomeStructure);
                        expect(anotherTestHomeStructure).to.equal(originalAnotherTestHomeStructure);

                        [dataManager removeObserverWithHandle:handle];

                        done();
                    }];
                });
            });

            it(@"should get structures", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    [dataManager structuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                        expect(error).to.equal(nil);

                        id <NestSDKStructure> anotherTestHomeStructure = structuresArray.firstObject;
                        id <NestSDKStructure> testHomeStructure = structuresArray.lastObject;

                        if (![testHomeStructure.name isEqual:@"Test Home"]) {
                            testHomeStructure = structuresArray.firstObject;
                            anotherTestHomeStructure = structuresArray.lastObject;
                        }

                        expect(testHomeStructure).to.equal(originalTestHomeStructure);
                        expect(anotherTestHomeStructure).to.equal(originalAnotherTestHomeStructure);

                        done();
                    }];
                });
            });


            it(@"should observe thermostat", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __block NestSDKObserverHandle handle = [dataManager observeThermostatWithId:@"OL3mkXXPwBo3eOg2StD2FXSa7y9rOYE0" block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(thermostat).to.equal(originalThermostat);

                        [dataManager removeObserverWithHandle:handle];

                        done();
                    }];
                });
            });

            it(@"should get thermostat", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    [dataManager thermostatWithId:@"OL3mkXXPwBo3eOg2StD2FXSa7y9rOYE0" block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(thermostat).to.equal(originalThermostat);

                        done();
                    }];
                });
            });

            it(@"should set thermostat", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                __block NestSDKThermostatDataModel *__thermostat;

                waitUntilTimeout(120, ^(DoneCallback done) {
                    [dataManager thermostatWithId:@"OL3mkXXPwBo3eOg2StD2FXSa7y9rOYE0" block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);
                        __thermostat = thermostat;

                        done();
                    }];
                });

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __thermostat.hvacMode = NestSDKThermostatHVACModeHeat;

                    [dataManager setThermostat:__thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(thermostat).to.equal(__thermostat);

                        done();
                    }];
                });

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __thermostat.targetTemperatureF = 53;

                    [dataManager setThermostat:__thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);

                        // Since we are setting fahrenheit degrees, celsius degrees may not equal
                        __thermostat.targetTemperatureC = thermostat.targetTemperatureC;

                        expect(thermostat).to.equal(__thermostat);

                        done();
                    }];
                });

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __thermostat.hvacMode = NestSDKThermostatHVACModeHeatCool;
                    __thermostat.fanTimerActive = true;

                    [dataManager setThermostat:__thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);

                        // Turning on fan timer will activate timeout
                        __thermostat.fanTimerTimeout = thermostat.fanTimerTimeout;

                        expect(thermostat).to.equal(__thermostat);

                        done();
                    }];
                });

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __thermostat.targetTemperatureHighF = 100;
                    __thermostat.targetTemperatureLowF = 44;

                    [dataManager setThermostat:__thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);

                        // Since we are setting fahrenheit degrees, celsius degrees may not equal
                        __thermostat.targetTemperatureHighC = thermostat.targetTemperatureHighC;
                        __thermostat.targetTemperatureLowC = thermostat.targetTemperatureLowC;

                        expect(thermostat).to.equal(__thermostat);

                        done();
                    }];
                });

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __thermostat.targetTemperatureHighF = 79;
                    __thermostat.targetTemperatureLowF = 66;

                    [dataManager setThermostat:__thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);

                        // Since we are setting fahrenheit degrees, celsius degrees may not equal
                        __thermostat.targetTemperatureHighC = thermostat.targetTemperatureHighC;
                        __thermostat.targetTemperatureLowC = thermostat.targetTemperatureLowC;

                        expect(thermostat).to.equal(__thermostat);

                        done();
                    }];
                });

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __thermostat.hvacMode = NestSDKThermostatHVACModeHeat;
                    __thermostat.fanTimerActive = false;
                    __thermostat.fanTimerTimeout = nil;

                    [dataManager setThermostat:__thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(thermostat).to.equal(__thermostat);

                        done();
                    }];
                });

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __thermostat.targetTemperatureF = 68;

                    [dataManager setThermostat:__thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);

                        // Since we are setting fahrenheit degrees, celsius degrees may not equal
                        __thermostat.targetTemperatureC = thermostat.targetTemperatureC;

                        expect(thermostat).to.equal(__thermostat);

                        done();
                    }];
                });
            });


            it(@"should observe smoke+CO alarm", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __block NestSDKObserverHandle handle = [dataManager observeSmokeCOAlarmWithId:@"CVRjKfVlTrl_4t65kH9CrnSa7y9rOYE0" block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(smokeCOAlarm).to.equal(originalSmokeCOAlarm);

                        [dataManager removeObserverWithHandle:handle];

                        done();
                    }];
                });
            });

            it(@"should get smoke+CO alarm", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    [dataManager smokeCOAlarmWithId:@"CVRjKfVlTrl_4t65kH9CrnSa7y9rOYE0" block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(smokeCOAlarm).to.equal(originalSmokeCOAlarm);

                        done();
                    }];
                });
            });


            it(@"should observe camera", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    __block NestSDKObserverHandle handle = [dataManager observeCameraWithId:@"qewrFbhxXs4p54xcKEg-K3VIwrcy-oxcf-3BRxAMJw6Ybv1ll7t4vg" block:^(id <NestSDKCamera> camera, NSError *error) {
                        expect(error).to.equal(nil);

                        // The hashes in these URL are random all the time
                        originalCamera.webUrl = camera.webUrl;
                        originalCamera.appUrl = camera.appUrl;

                        expect(camera).to.equal(originalCamera);

                        [dataManager removeObserverWithHandle:handle];

                        done();
                    }];
                });
            });

            it(@"should get camera", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    [dataManager cameraWithId:@"qewrFbhxXs4p54xcKEg-K3VIwrcy-oxcf-3BRxAMJw6Ybv1ll7t4vg" block:^(id <NestSDKCamera> camera, NSError *error) {
                        expect(error).to.equal(nil);

                        // The hashes in these URL are random all the time
                        originalCamera.webUrl = camera.webUrl;
                        originalCamera.appUrl = camera.appUrl;

                        expect(camera).to.equal(originalCamera);

                        done();
                    }];
                });
            });

            it(@"should set camera", ^{
                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntilTimeout(120, ^(DoneCallback done) {
                    originalCamera.isStreaming = false;

                    [dataManager setCamera:originalCamera block:^(id <NestSDKCamera> camera, NSError *error) {
                        expect(error).to.equal(nil);

                        // The hashes in these URL are random all the time
                        originalCamera.webUrl = camera.webUrl;
                        originalCamera.appUrl = camera.appUrl;

                        // Unable to set isStreaming to false on virtual device
                        originalCamera.isStreaming = true;

                        expect(camera).to.equal(originalCamera);

                        done();
                    }];
                });
            });
        });
    }
SpecEnd