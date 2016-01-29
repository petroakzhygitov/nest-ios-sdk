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

SpecBegin(NestSDKProductSoftwareDataModel)
    {
        describe(@"NestSDKProductSoftwareDataModel", ^{

            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"product.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
//                NSError *error;
//                NestSDKDeviceDataModel *device = [[NestSDKDeviceDataModel alloc] initWithData:data error:&error];
//                expect(error).to.equal(nil);
//
//                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//
//                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//                dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//                dateComponents.year = 2015;
//                dateComponents.month = 10;
//                dateComponents.day = 31;
//                dateComponents.hour = 23;
//                dateComponents.minute = 59;
//                dateComponents.second = 59;
//
//                NSDate *lastConnectionDate = [calendar dateFromComponents:dateComponents];
//
//                expect(device.deviceId).to.equal(@"peyiJNo0IldT2YlIVtYaGQ");
//                expect(device.softwareVersion).to.equal(@"4.0");
//                expect(device.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");
//                expect(device.name).to.equal(@"Hallway (upstairs)");
//                expect(device.nameLong).to.equal(@"Hallway Thermostat (upstairs)");
//                expect(device.isOnline).to.equal(YES);
//                expect(device.whereId).to.equal(@"UNCBGUnN24...");
//
//                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[device toJSONData] options:kNilOptions error:&error];
//                expect(error).to.equal(nil);
//
//                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//                expect(error).to.equal(nil);
//
//                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
//                NSError *error;
//                NestSDKDeviceDataModel *device1 = [[NestSDKDeviceDataModel alloc] initWithData:data error:&error];
//                expect(error).to.equal(nil);
//
//                NestSDKDeviceDataModel *device2 = [[NestSDKDeviceDataModel alloc] initWithData:data error:&error];
//                expect(error).to.equal(nil);
//
//                NestSDKDeviceDataModel *device3 = [[NestSDKDeviceDataModel alloc] initWithData:data error:&error];
//                expect(error).to.equal(nil);
//
//                device3.name = @"someName";
//
//                expect(device1.hash).to.equal(device2.hash);
//                expect(device1.hash).notTo.equal(device3.hash);
//
//                expect(device1).to.equal(device2);
//                expect(device1).notTo.equal(device3);
            });
        });
    }
SpecEnd