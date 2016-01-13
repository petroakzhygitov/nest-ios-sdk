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

SpecBegin(NestSDKStructure)
    {
        describe(@"NestSDKStructure", ^{

            __block NSString *resourcePath;

            beforeAll(^{
                resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
            });

            it(@"should deserialize/serialize data", ^{
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"structure.json"];
                NSData *data = [NSData dataWithContentsOfFile:dataPath];

                NSError *error;
                NestSDKStructure *structure = [[NestSDKStructure alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                expect(structure.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");
                expect(structure.thermostats.count).to.equal(2);
                expect(structure.smokeCoAlarms.count).to.equal(2);
                expect(structure.cameras.count).to.equal(2);
                expect(structure.away).to.equal(NestSDKStructureAwayStateAutoAway);
                expect(structure.name).to.equal(@"Home");
                expect(structure.countryCode).to.equal(@"US");
                expect(structure.postalCode).to.equal(@"94304");
                expect(structure.wheres).notTo.equal(nil);
                expect(structure.peakPeriodStartTime).notTo.equal(nil);
                expect(structure.peakPeriodEndTime).notTo.equal(nil);
//                    "peak_period_start_time": "2015-10-31T23:59:59.000Z",
//                    "peak_period_end_time": "2015-10-31T23:59:59.000Z",
                expect(structure.timeZone).to.equal(@"America/Los_Angeles");
//                    "eta": {
//                "trip_id": "myTripHome1024",
//                        "estimated_arrival_window_begin": "2015-10-31T22:42:59.000Z",
//                        "estimated_arrival_window_end": "2015-10-31T23:59:59.000Z"
//            },
                expect(structure.rhrEnrollment).to.equal(YES);

                NSLog([structure toJSONString]);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[structure toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });
        });
    }
SpecEnd