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
#import "NestSDKThermostatDataModel.h"

SpecBegin(NestSDKThermostatDataModel)
    {
        describe(@"NestSDKThermostatDataModel", ^{

            __block NSData *data;

            __block NSDate *lastConnectionDate;
            __block NSDate *fanTimerTimeoutDate;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"thermostat.json"];

                data = [NSData dataWithContentsOfFile:dataPath];

                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateComponents.year = 2015;
                dateComponents.month = 10;
                dateComponents.day = 31;
                dateComponents.hour = 23;
                dateComponents.minute = 59;
                dateComponents.second = 59;

                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

                lastConnectionDate = [calendar dateFromComponents:dateComponents];
                fanTimerTimeoutDate = [calendar dateFromComponents:dateComponents];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKThermostatDataModel *thermostat = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                expect(thermostat.deviceId).to.equal(@"peyiJNo0IldT2YlIVtYaGQ");
                expect(thermostat.locale).to.equal(@"en-US");
                expect(thermostat.softwareVersion).to.equal(@"4.0");
                expect(thermostat.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");
                expect(thermostat.name).to.equal(@"Hallway (upstairs)");
                expect(thermostat.nameLong).to.equal(@"Hallway Thermostat (upstairs)");
                expect(thermostat.lastConnection).to.equal(lastConnectionDate);
                expect(thermostat.isOnline).to.equal(YES);
                expect(thermostat.whereId).to.equal(@"UNCBGUnN24...");
                expect(thermostat.canCool).to.equal(YES);
                expect(thermostat.canHeat).to.equal(YES);
                expect(thermostat.isUsingEmergencyHeat).to.equal(YES);
                expect(thermostat.hasFan).to.equal(YES);
                expect(thermostat.fanTimerActive).to.equal(YES);
                expect(thermostat.fanTimerTimeout).to.equal(fanTimerTimeoutDate);
                expect(thermostat.hasLeaf).to.equal(YES);
                expect(thermostat.temperatureScale).to.equal(NestSDKThermostatTemperatureScaleC);
                expect(thermostat.targetTemperatureF).to.equal(72);
                expect(thermostat.targetTemperatureC).to.equal(21.5);
                expect(thermostat.targetTemperatureHighF).to.equal(72);
                expect(thermostat.targetTemperatureHighC).to.equal(21.5);
                expect(thermostat.targetTemperatureLowF).to.equal(64);
                expect(thermostat.targetTemperatureLowC).to.equal(17.5);
                expect(thermostat.awayTemperatureHighF).to.equal(72);
                expect(thermostat.awayTemperatureHighC).to.equal(21.5);
                expect(thermostat.awayTemperatureLowF).to.equal(64);
                expect(thermostat.awayTemperatureLowC).to.equal(17.5);
                expect(thermostat.hvacMode).to.equal(NestSDKThermostatHVACModeHeat);
                expect(thermostat.ambientTemperatureF).to.equal(72);
                expect(thermostat.ambientTemperatureC).to.equal(21.5);
                expect(thermostat.humidity).to.equal(40);
                expect(thermostat.hvacState).to.equal(NestSDKThermostatHVACStateHeating);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[thermostat toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKThermostatDataModel *thermostat1 = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKThermostatDataModel *thermostat2 = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKThermostatDataModel *thermostat3 = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                thermostat3.humidity = 42;

                expect(thermostat1.hash).to.equal(thermostat2.hash);
                expect(thermostat1.hash).notTo.equal(thermostat3.hash);

                expect(thermostat1).to.equal(thermostat2);
                expect(thermostat1).notTo.equal(thermostat3);
            });

            it(@"should filter target temperature values", ^{
                NSError *error;
                NestSDKThermostatDataModel *thermostat = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                thermostat.targetTemperatureC = -2;
                expect(thermostat.targetTemperatureC).to.equal(9);

                thermostat.targetTemperatureHighC = 0;
                expect(thermostat.targetTemperatureHighC).to.equal(9);

                thermostat.targetTemperatureLowC = -15;
                expect(thermostat.targetTemperatureLowC).to.equal(9);

                thermostat.targetTemperatureF = 5;
                expect(thermostat.targetTemperatureF).to.equal(50);

                thermostat.targetTemperatureHighF = 0;
                expect(thermostat.targetTemperatureHighF).to.equal(50);

                thermostat.targetTemperatureLowF = 15;
                expect(thermostat.targetTemperatureLowF).to.equal(50);

                thermostat.targetTemperatureC = 50;
                expect(thermostat.targetTemperatureC).to.equal(32);

                thermostat.targetTemperatureHighC = 44;
                expect(thermostat.targetTemperatureHighC).to.equal(32);

                thermostat.targetTemperatureLowC = 33;
                expect(thermostat.targetTemperatureLowC).to.equal(32);

                thermostat.targetTemperatureF = 105;
                expect(thermostat.targetTemperatureF).to.equal(90);

                thermostat.targetTemperatureHighF = 100;
                expect(thermostat.targetTemperatureHighF).to.equal(90);

                thermostat.targetTemperatureLowF = 155;
                expect(thermostat.targetTemperatureLowF).to.equal(90);
            });

            it(@"should convert to writable dictionary", ^{
                NSError *error;
                NestSDKThermostatDataModel *thermostat = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                thermostat.temperatureScale = NestSDKThermostatTemperatureScaleC;
                NSDictionary *thermostatDictionary = [thermostat toWritableDataModelDictionary];

                expect(thermostatDictionary.allKeys.count).to.equal(5);
                expect(thermostatDictionary[@"fan_timer_active"]).to.equal(YES);
                expect(thermostatDictionary[@"hvac_mode"]).to.equal(@"heat");
                expect(thermostatDictionary[@"target_temperature_c"]).to.equal(21.5);
                expect(thermostatDictionary[@"target_temperature_high_c"]).to.equal(21.5);
                expect(thermostatDictionary[@"target_temperature_low_c"]).to.equal(17.5);

                thermostat.temperatureScale = NestSDKThermostatTemperatureScaleF;
                thermostatDictionary = [thermostat toWritableDataModelDictionary];

                expect(thermostatDictionary.allKeys.count).to.equal(5);
                expect(thermostatDictionary[@"fan_timer_active"]).to.equal(YES);
                expect(thermostatDictionary[@"hvac_mode"]).to.equal(@"heat");
                expect(thermostatDictionary[@"target_temperature_f"]).to.equal(72);
                expect(thermostatDictionary[@"target_temperature_high_f"]).to.equal(72);
                expect(thermostatDictionary[@"target_temperature_low_f"]).to.equal(64);
            });

            it(@"should copy", ^{
                NSError *error;
                NestSDKThermostatDataModel *thermostat = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKThermostatDataModel *thermostat2 = [thermostat copy];
                expect(thermostat).to.equal(thermostat2);
            });
        });
    }
SpecEnd