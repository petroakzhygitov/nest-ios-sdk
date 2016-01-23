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
#import "NestSDKDataManager.h"
#import "NestSDKApplicationDelegate.h"
#import "NestSDKFirebaseService.h"
#import "NestSDKMetadataDataModel.h"
#import "NestSDKError.h"
#import "NestSDKStructureDataModel.h"
#import "NestSDKThermostatDataModel.h"
#import "NestSDKCameraDataModel.h"
#import "NestSDKSmokeCOAlarm.h"


SpecBegin(NestSDKDataManager)
    {
        describe(@"NestSDKDataManager", ^{

            __block NSString *resourcePath;

            __block id firebaseServiceMock;
            __block id appDelegateMock;

            beforeAll(^{
                resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
            });

            beforeEach(^{
                firebaseServiceMock = [OCMockObject mockForClass:[NestSDKFirebaseService class]];

                appDelegateMock = [OCMockObject partialMockForObject:[NestSDKApplicationDelegate sharedInstance]];
                [[[appDelegateMock stub] andReturn:firebaseServiceMock] service];
            });

            afterEach(^{
                [firebaseServiceMock stopMocking];
                [appDelegateMock stopMocking];
            });

            it(@"should get metadata", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"metadata.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] valuesForURL:@"/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager metadataWithBlock:^(NestSDKMetadataDataModel *metadata, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(metadata.accessToken).to.equal(@"c.FmDPkzyzaQe...");
                        expect(metadata.clientVersion).to.equal(1);

                        done();
                    }];
                });
            });

            it(@"should not get metadata", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    updateBlock(@"bad_dictionary", nil);

                }] valuesForURL:@"/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager metadataWithBlock:^(NestSDKMetadataDataModel *metadata, NSError *error) {
                        expect(metadata).to.equal(nil);
                        expect(error.domain).to.equal(NestSDKErrorDomain);
                        expect(error.code).to.equal(NestSDKErrorCodeUnexpectedArgumentType);

                        done();
                    }];
                });
            });

            it(@"should get structures", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"structures.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] valuesForURL:@"structures/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager structuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                        expect(error).to.equal(nil);

                        NestSDKStructureDataModel *structure = structuresArray.firstObject;
                        expect(structure.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");

                        done();
                    }];
                });
            });

            it(@"should not get structures", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    updateBlock(@"bad_dictionary", nil);

                }] valuesForURL:@"structures/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager structuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                        expect(structuresArray).to.equal(nil);
                        expect(error.domain).to.equal(NestSDKErrorDomain);
                        expect(error.code).to.equal(NestSDKErrorCodeUnexpectedArgumentType);

                        done();
                    }];
                });
            });

            it(@"should observe structures", ^{
                [[[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"structures.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] andReturnValue:@(42)] observeValuesForURL:@"structures/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                __block NestSDKObserverHandle handle;
                waitUntil(^(DoneCallback done) {
                    handle = [dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                        expect(error).to.equal(nil);

                        NestSDKStructureDataModel *structure = structuresArray.firstObject;
                        expect(structure.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");

                        done();
                    }];
                });

                expect(handle).to.equal(42);
            });

            it(@"should set structure", ^{
                NSString *filePath = [resourcePath stringByAppendingPathComponent:@"structure.json"];
                NSData *data = [NSData dataWithContentsOfFile:filePath];

                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:4];

                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] setValues:[OCMArg any] forURL:@"structures/VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                NSError *error;
                NestSDKStructureDataModel *structure = [[NestSDKStructureDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                waitUntil(^(DoneCallback done) {
                    [dataManager setStructure:structure block:^(id <NestSDKStructure> updatedStructure, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(structure).to.equal(updatedStructure);

                        done();
                    }];
                });
            });

            it(@"should get thermostat", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"thermostat.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] valuesForURL:@"devices/thermostats/t1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager thermostatWithId:@"t1" block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(thermostat.deviceId).to.equal(@"peyiJNo0IldT2YlIVtYaGQ");

                        done();
                    }];
                });
            });

            it(@"should not get thermostat", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    updateBlock(@"bad_dictionary", nil);

                }] valuesForURL:@"devices/thermostats/t1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager thermostatWithId:@"t1" block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(thermostat).to.equal(nil);
                        expect(error.domain).to.equal(NestSDKErrorDomain);
                        expect(error.code).to.equal(NestSDKErrorCodeUnexpectedArgumentType);

                        done();
                    }];
                });
            });

            it(@"should observe thermostat", ^{
                [[[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"thermostat.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] andReturnValue:@(42)] observeValuesForURL:@"devices/thermostats/t1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                __block NestSDKObserverHandle handle;
                waitUntil(^(DoneCallback done) {
                    handle = [dataManager observeThermostatWithId:@"t1" block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(thermostat.deviceId).to.equal(@"peyiJNo0IldT2YlIVtYaGQ");

                        done();
                    }];
                });

                expect(handle).to.equal(42);
            });

            it(@"should set thermostat", ^{
                NSString *filePath = [resourcePath stringByAppendingPathComponent:@"thermostat.json"];
                NSData *data = [NSData dataWithContentsOfFile:filePath];

                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:4];

                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] setValues:[OCMArg any] forURL:@"devices/thermostats/peyiJNo0IldT2YlIVtYaGQ/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                NSError *error;
                NestSDKThermostatDataModel *thermostat = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                waitUntil(^(DoneCallback done) {
                    [dataManager setThermostat:thermostat block:^(id <NestSDKThermostat> updatedThermostat, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(thermostat).to.equal(updatedThermostat);

                        done();
                    }];
                });
            });

            it(@"should get smoke+CO alarm", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"smoke_co_alarm.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] valuesForURL:@"devices/smoke_co_alarms/s1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager smokeCOAlarmWithId:@"s1" block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(smokeCOAlarm.deviceId).to.equal(@"RTMTKxsQTCxzVcsySOHPxKoF4OyCifrs");

                        done();
                    }];
                });
            });

            it(@"should not get smoke+CO alarm", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    updateBlock(@"bad_dictionary", nil);

                }] valuesForURL:@"devices/smoke_co_alarms/s1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager smokeCOAlarmWithId:@"s1" block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
                        expect(smokeCOAlarm).to.equal(nil);
                        expect(error.domain).to.equal(NestSDKErrorDomain);
                        expect(error.code).to.equal(NestSDKErrorCodeUnexpectedArgumentType);

                        done();
                    }];
                });
            });

            it(@"should observe smoke+CO alarm", ^{
                [[[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"smoke_co_alarm.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] andReturnValue:@(42)] observeValuesForURL:@"devices/smoke_co_alarms/s1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                __block NestSDKObserverHandle handle;
                waitUntil(^(DoneCallback done) {
                    handle = [dataManager observeSmokeCOAlarmWithId:@"s1" block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(smokeCOAlarm.deviceId).to.equal(@"RTMTKxsQTCxzVcsySOHPxKoF4OyCifrs");

                        done();
                    }];
                });

                expect(handle).to.equal(42);
            });

            it(@"should get camera", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"camera.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] valuesForURL:@"devices/cameras/c1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager cameraWithId:@"c1" block:^(id <NestSDKCamera> camera, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(camera.deviceId).to.equal(@"awJo6rH...");

                        done();
                    }];
                });
            });

            it(@"should not get camera", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    updateBlock(@"bad_dictionary", nil);

                }] valuesForURL:@"devices/cameras/c1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager cameraWithId:@"c1" block:^(id <NestSDKCamera> camera, NSError *error) {
                        expect(camera).to.equal(nil);
                        expect(error.domain).to.equal(NestSDKErrorDomain);
                        expect(error.code).to.equal(NestSDKErrorCodeUnexpectedArgumentType);

                        done();
                    }];
                });
            });

            it(@"should observe camera", ^{
                [[[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"camera.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] andReturnValue:@(42)] observeValuesForURL:@"devices/cameras/c1/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                __block NestSDKObserverHandle handle;
                waitUntil(^(DoneCallback done) {
                    handle = [dataManager observeCameraWithId:@"c1" block:^(id <NestSDKCamera> camera, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(camera.deviceId).to.equal(@"awJo6rH...");

                        done();
                    }];
                });

                expect(handle).to.equal(42);
            });

            it(@"should set camera", ^{
                NSString *filePath = [resourcePath stringByAppendingPathComponent:@"camera.json"];
                NSData *data = [NSData dataWithContentsOfFile:filePath];

                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:4];

                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] setValues:[OCMArg any] forURL:@"devices/cameras/awJo6rH.../" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                NSError *error;
                NestSDKCameraDataModel *camera = [[NestSDKCameraDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                waitUntil(^(DoneCallback done) {
                    [dataManager setCamera:camera block:^(id <NestSDKCamera> updatedCamera, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(camera).to.equal(updatedCamera);

                        done();
                    }];
                });
            });

            it(@"should remove observer", ^{
                [[[firebaseServiceMock stub] andReturnValue:@(1)] observeValuesForURL:@"structures/" withBlock:[OCMArg any]];
                [[[firebaseServiceMock stub] andReturnValue:@(2)] observeValuesForURL:@"devices/thermostats/t1/" withBlock:[OCMArg any]];
                [[[firebaseServiceMock stub] andReturnValue:@(3)] observeValuesForURL:@"devices/smoke_co_alarms/s1/" withBlock:[OCMArg any]];
                [[[firebaseServiceMock stub] andReturnValue:@(4)] observeValuesForURL:@"devices/cameras/c1/" withBlock:[OCMArg any]];
                [[[firebaseServiceMock stub] andReturnValue:@(5)] observeValuesForURL:@"devices/cameras/c2/" withBlock:[OCMArg any]];

                [[firebaseServiceMock expect] removeObserverWithHandle:1];
                [[firebaseServiceMock expect] removeObserverWithHandle:2];
                [[firebaseServiceMock expect] removeObserverWithHandle:3];
                [[firebaseServiceMock expect] removeObserverWithHandle:5];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    NestSDKObserverHandle handle1 = [dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                    }];
                    NestSDKObserverHandle handle2 = [dataManager observeThermostatWithId:@"t1" block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                    }];
                    NestSDKObserverHandle handle3 = [dataManager observeSmokeCOAlarmWithId:@"s1" block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
                    }];
                    NestSDKObserverHandle handle4 = [dataManager observeCameraWithId:@"c1" block:^(id <NestSDKCamera> camera, NSError *error) {
                    }];
                    NestSDKObserverHandle handle5 = [dataManager observeCameraWithId:@"c2" block:^(id <NestSDKCamera> camera, NSError *error) {
                    }];

                    [firebaseServiceMock removeObserverWithHandle:handle1];
                    [firebaseServiceMock removeObserverWithHandle:handle2];
                    [firebaseServiceMock removeObserverWithHandle:handle3];
                    [firebaseServiceMock removeObserverWithHandle:handle5];

                    [firebaseServiceMock verify];

                    done();
                });
            });

            it(@"should remove all observers", ^{
                [[[firebaseServiceMock stub] andReturnValue:@(1)] observeValuesForURL:@"structures/" withBlock:[OCMArg any]];
                [[[firebaseServiceMock stub] andReturnValue:@(2)] observeValuesForURL:@"devices/thermostats/t1/" withBlock:[OCMArg any]];
                [[[firebaseServiceMock stub] andReturnValue:@(3)] observeValuesForURL:@"devices/smoke_co_alarms/s1/" withBlock:[OCMArg any]];
                [[[firebaseServiceMock stub] andReturnValue:@(4)] observeValuesForURL:@"devices/cameras/c1/" withBlock:[OCMArg any]];
                [[[firebaseServiceMock stub] andReturnValue:@(5)] observeValuesForURL:@"devices/cameras/c2/" withBlock:[OCMArg any]];

                [[firebaseServiceMock expect] removeAllObservers];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                    }];
                    [dataManager observeThermostatWithId:@"t1" block:^(id <NestSDKThermostat> thermostat, NSError *error) {
                    }];
                    [dataManager observeSmokeCOAlarmWithId:@"s1" block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
                    }];
                    [dataManager observeCameraWithId:@"c1" block:^(id <NestSDKCamera> camera, NSError *error) {
                    }];
                    [dataManager observeCameraWithId:@"c2" block:^(id <NestSDKCamera> camera, NSError *error) {
                    }];

                    [firebaseServiceMock removeAllObservers];

                    [firebaseServiceMock verify];

                    done();
                });
            });
        });
    }
SpecEnd