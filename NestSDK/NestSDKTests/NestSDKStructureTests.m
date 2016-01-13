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
#import "NestSDKStructure.h"
#import "NestSDKWheres.h"

SpecBegin(NestSDKStructure)
    {
        describe(@"NestSDKStructure", ^{

            __block NSString *resourcePath;

            beforeAll(^{
                resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;

                NSString *structureJSONPath = [resourcePath stringByAppendingPathComponent:@"structure.json"];
                NSData *structureData = [NSData dataWithContentsOfFile:structureJSONPath];

                NestSDKStructure *structure = [[NestSDKStructure alloc] initWithData:structureData error:&error];
                expect(error).to.equal(nil);

                NSString *wheresJSONPath = [resourcePath stringByAppendingPathComponent:@"wheres.json"];
                NSData *wheresData = [NSData dataWithContentsOfFile:wheresJSONPath];

                NestSDKWheres *wheres = [[NestSDKWheres alloc] initWithData:wheresData error:&error];
                expect(error).to.equal(nil);


                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateComponents.year = 2015;
                dateComponents.month = 10;
                dateComponents.day = 31;
                dateComponents.hour = 23;
                dateComponents.minute = 55;
                dateComponents.second = 59;

                NSDate *peakPeriodStartTimeDate = [calendar dateFromComponents:dateComponents];

                dateComponents.minute = 59;
                NSDate *peakPeriodEndTimeDate = [calendar dateFromComponents:dateComponents];

//                expect(structure.devicesDictionary.allValues.firstObject).to.equal(devices);

                expect(structure.away).to.equal(NestSDKStructureAwayStateAutoAway);
                expect(structure.name).to.equal(@"Home");
                expect(structure.countryCode).to.equal(@"US");
                expect(structure.postalCode).to.equal(@"94304");
                expect(structure.peakPeriodStartTime).to.equal(peakPeriodStartTimeDate);
                expect(structure.peakPeriodEndTime).to.equal(peakPeriodEndTimeDate);
                expect(structure.timeZone).to.equal(@"America/Los_Angeles");
                expect(structure.wheres.allValues.firstObject).to.equal(wheres);
//                    "eta": {
//                "trip_id": "myTripHome1024",
//                        "estimated_arrival_window_begin": "2015-10-31T22:42:59.000Z",
//                        "estimated_arrival_window_end": "2015-10-31T23:59:59.000Z"
//            },
                expect(structure.rhrEnrollment).to.equal(YES);

                NSLog([structure toJSONString]);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[structure toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:structureData options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });
        });
    }
SpecEnd