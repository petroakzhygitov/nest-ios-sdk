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

SpecBegin(NestSDKCameraLastEvent)
    {
        describe(@"NestSDKCameraLastEvent", ^{

            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"camera_last_event.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKCameraLastEvent *lastEvent = [[NestSDKCameraLastEvent alloc] initWithData:data error:&error];
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

                NSDate *startTimeDate = [calendar dateFromComponents:dateComponents];

                expect(lastEvent.hasSound).to.equal(YES);
                expect(lastEvent.hasMotion).to.equal(YES);
                expect(lastEvent.startTime).to.equal(startTimeDate);

                dateComponents.hour = 19;
                dateComponents.minute = 44;

                NSDate *endTimeDate = [calendar dateFromComponents:dateComponents];

                expect(lastEvent.endTime).to.equal(endTimeDate);
                expect(lastEvent.webUrl).to.equal(@"https://home.nest.com/cameras/device_id?auth=access_token");
                expect(lastEvent.appUrl).to.equal(@"nestmobile://cameras/device_id?auth=access_token");
                expect(lastEvent.imageUrl).to.equal(@"nestmobile://cameras/device_id?auth=access_token&image=true");
                expect(lastEvent.animatedImageUrl).to.equal(@"nestmobile://cameras/device_id?auth=access_token&animated_image=true");

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[lastEvent toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKCameraLastEvent *lastEvent1 = [[NestSDKCameraLastEvent alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKCameraLastEvent *lastEvent2 = [[NestSDKCameraLastEvent alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKCameraLastEvent *lastEvent3 = [[NestSDKCameraLastEvent alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                lastEvent3.appUrl = @"someURL";

                expect(lastEvent1.hash).to.equal(lastEvent2.hash);
                expect(lastEvent1.hash).notTo.equal(lastEvent3.hash);

                expect(lastEvent1).to.equal(lastEvent2);
                expect(lastEvent1).notTo.equal(lastEvent3);
            });
        });
    }
SpecEnd