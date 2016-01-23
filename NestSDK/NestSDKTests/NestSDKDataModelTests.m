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
#import "NestSDKMetadataDataModel.h"
#import "NestSDKDeviceDataModel.h"
#import "NestSDKCameraDataModel.h"
#import "NestSDKThermostatDataModel.h"
#import "NestSDKSmokeCOAlarmDataModel.h"
#import "NestSDKStructureDataModel.h"

SpecBegin(NestSDKDataModel)
    {
        describe(@"NestSDKDataModel", ^{

            it(@"should convert models to writable dictionary", ^{
                NSError *error;
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;

                NSString *cameraDataPath = [resourcePath stringByAppendingPathComponent:@"camera.json"];
                NSData *cameraData = [NSData dataWithContentsOfFile:cameraDataPath];

                NestSDKCameraDataModel *camera = [[NestSDKCameraDataModel alloc] initWithData:cameraData error:&error];
                expect(error).to.equal(nil);

                NSDictionary *cameraDictionary = [camera toWritableDataModelDictionary];
                expect(cameraDictionary.allKeys.count).to.equal(1);
                expect(cameraDictionary[@"is_streaming"]).notTo.equal(nil);


                NSString *thermostatDataPath = [resourcePath stringByAppendingPathComponent:@"thermostat.json"];
                NSData *thermostatData = [NSData dataWithContentsOfFile:thermostatDataPath];

                NestSDKThermostatDataModel *thermostat = [[NestSDKThermostatDataModel alloc] initWithData:thermostatData error:&error];
                expect(error).to.equal(nil);

                NSDictionary *thermostatDictionary = [thermostat toWritableDataModelDictionary];
                expect(thermostatDictionary.allKeys.count).to.equal(9);
                expect(thermostatDictionary[@"fan_timer_active"]).notTo.equal(nil);

                
                NSString *smokeCOAlarmDataPath = [resourcePath stringByAppendingPathComponent:@"smoke_co_alarm.json"];
                NSData *smokeCOAlarmData = [NSData dataWithContentsOfFile:smokeCOAlarmDataPath];

                NestSDKSmokeCOAlarmDataModel *smokeCOAlarm = [[NestSDKSmokeCOAlarmDataModel alloc] initWithData:smokeCOAlarmData error:&error];
                expect(error).to.equal(nil);

                NSDictionary *smokeCOAlarmDictionary = [smokeCOAlarm toWritableDataModelDictionary];
                expect(smokeCOAlarmDictionary.allKeys.count).to.equal(0);


                NSString *structureDataPath = [resourcePath stringByAppendingPathComponent:@"structure.json"];
                NSData *structureData = [NSData dataWithContentsOfFile:structureDataPath];

                NestSDKStructureDataModel *structure = [[NestSDKStructureDataModel alloc] initWithData:structureData error:&error];
                expect(error).to.equal(nil);

                NSDictionary *structureDictionary = [structure toWritableDataModelDictionary];
                expect(structureDictionary.allKeys.count).to.equal(2);
                expect(structureDictionary[@"eta"]).notTo.equal(nil);
            });
        });
    }
SpecEnd