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
#import "NestSDKAccessToken.h"
#import "LSStubRequestDSL.h"
#import "LSNocilla.h"
#import "NestSDKMetadataDataModel.h"
#import "NestSDKDeviceDataModel.h"
#import "NestSDKCameraDataModel.h"
#import "NestSDKCameraLastEventDataModel.h"
#import "NestSDKSmokeCOAlarmDataModel.h"

SpecBegin(NestSDKSmokeCOAlarmDataModel)
    {
        describe(@"NestSDKSmokeCOAlarmDataModel", ^{

            __block NSData *data;
            __block NSString *resourcePath;

            beforeAll(^{
                resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"smoke_co_alarm.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKSmokeCOAlarmDataModel *smokeCOAlarm = [[NestSDKSmokeCOAlarmDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateComponents.year = 2015;
                dateComponents.month = 10;
                dateComponents.day = 31;
                dateComponents.hour = 23;
                dateComponents.minute = 59;
                dateComponents.second = 59;

                NSDate *lastConnectionDate = [calendar dateFromComponents:dateComponents];

                expect(smokeCOAlarm.deviceId).to.equal(@"RTMTKxsQTCxzVcsySOHPxKoF4OyCifrs");
                expect(smokeCOAlarm.locale).to.equal(@"en-US");
                expect(smokeCOAlarm.softwareVersion).to.equal(@"1.01");
                expect(smokeCOAlarm.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");
                expect(smokeCOAlarm.name).to.equal(@"Hallway (upstairs)");
                expect(smokeCOAlarm.nameLong).to.equal(@"Hallway Protect (upstairs)");
                expect(smokeCOAlarm.lastConnection).to.equal(lastConnectionDate);
                expect(smokeCOAlarm.isOnline).to.equal(YES);
                expect(smokeCOAlarm.whereId).to.equal(@"UNCBGUnN24...");

                expect(smokeCOAlarm.batteryHealth).to.equal(NestSDKSmokeCOAlarmBatteryHealthOk);
                expect(smokeCOAlarm.coAlarmState).to.equal(NestSDKSmokeCOAlarmAlarmStateOk);
                expect(smokeCOAlarm.smokeAlarmState).to.equal(NestSDKSmokeCOAlarmAlarmStateOk);
                expect(smokeCOAlarm.isManualTestActive).to.equal(YES);
                expect(smokeCOAlarm.lastManualTestTime).to.equal(lastConnectionDate);
                expect(smokeCOAlarm.uiColorState).to.equal(NestSDKSmokeCOAlarmUIColorStateGray);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[smokeCOAlarm toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKSmokeCOAlarmDataModel *smokeCOAlarm1 = [[NestSDKSmokeCOAlarmDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKSmokeCOAlarmDataModel *smokeCOAlarm2 = [[NestSDKSmokeCOAlarmDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKSmokeCOAlarmDataModel *smokeCOAlarm3 = [[NestSDKSmokeCOAlarmDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                smokeCOAlarm3.uiColorState = NestSDKSmokeCOAlarmUIColorStateYellow;

                expect(smokeCOAlarm1.hash).to.equal(smokeCOAlarm2.hash);
                expect(smokeCOAlarm1.hash).notTo.equal(smokeCOAlarm3.hash);

                expect(smokeCOAlarm1).to.equal(smokeCOAlarm2);
                expect(smokeCOAlarm1).notTo.equal(smokeCOAlarm3);
            });
        });
    }
SpecEnd