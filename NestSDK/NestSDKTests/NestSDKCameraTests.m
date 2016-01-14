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
#import "NestSDKMetadata.h"
#import "NestSDKDevice.h"
#import "NestSDKCamera.h"
#import "NestSDKCameraLastEvent.h"

SpecBegin(NestSDKCamera)
    {
        describe(@"NestSDKCamera", ^{

            __block NSData *data;
            __block NSString *resourcePath;

            beforeAll(^{
                resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"camera.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKCamera *camera = [[NestSDKCamera alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NSString *lastEventJSONPath = [resourcePath stringByAppendingPathComponent:@"camera_last_event.json"];
                NSData *lastEventData = [NSData dataWithContentsOfFile:lastEventJSONPath];

                NestSDKCameraLastEvent *lastEvent = [[NestSDKCameraLastEvent alloc] initWithData:lastEventData error:&error];
                expect(error).to.equal(nil);

                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.year = 2015;
                dateComponents.month = 12;
                dateComponents.day = 29;
                dateComponents.hour = 18;
                dateComponents.minute = 42;
                dateComponents.second = 00;

                NSDate *lastIsOnlineChangeDate = [calendar dateFromComponents:dateComponents];

                expect(camera.deviceId).to.equal(@"awJo6rH...");
                expect(camera.softwareVersion).to.equal(@"4.0");
                expect(camera.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");
                expect(camera.name).to.equal(@"Hallway (upstairs)");
                expect(camera.nameLong).to.equal(@"Hallway Camera (upstairs)");
                expect(camera.isOnline).to.equal(YES);
                expect(camera.whereId).to.equal(@"d6reb_OZTM...");

                expect(camera.isStreaming).to.equal(YES);
                expect(camera.isAudioInputEnabled).to.equal(YES);
                expect(camera.lastIsOnlineChange).to.equal(lastIsOnlineChangeDate);
                expect(camera.isVideoHistoryEnabled).to.equal(YES);
                expect(camera.webUrl).to.equal(@"https://home.nest.com/cameras/device_id?auth=access_token");
                expect(camera.appUrl).to.equal(@"nestmobile://cameras/device_id?auth=access_token");
                expect(camera.lastEvent).to.equal(lastEvent);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[camera toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKCamera *camera1 = [[NestSDKCamera alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKCamera *camera2 = [[NestSDKCamera alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKCamera *camera3 = [[NestSDKCamera alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                camera3.appUrl = @"someURL";

                expect(camera1.hash).to.equal(camera2.hash);
                expect(camera1.hash).notTo.equal(camera3.hash);

                expect(camera1).to.equal(camera2);
                expect(camera1).notTo.equal(camera3);
            });
        });
    }
SpecEnd