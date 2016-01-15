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
#import "NestSDKETADataModel.h"

SpecBegin(NestSDKETA)
    {
        describe(@"NestSDKETADataModel", ^{

            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"eta.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKETADataModel *eta = [[NestSDKETADataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateComponents.year = 2015;
                dateComponents.month = 10;
                dateComponents.day = 31;
                dateComponents.hour = 22;
                dateComponents.minute = 42;
                dateComponents.second = 59;

                NSDate *estimatedArrivalWindowBeginDate = [calendar dateFromComponents:dateComponents];

                dateComponents.hour = 23;
                dateComponents.minute = 59;
                NSDate *estimatedArrivalWindowEndDate = [calendar dateFromComponents:dateComponents];

                expect(eta.tripId).to.equal(@"myTripHome1024");
                expect(eta.estimatedArrivalWindowBegin).to.equal(estimatedArrivalWindowBeginDate);
                expect(eta.estimatedArrivalWindowEnd).to.equal(estimatedArrivalWindowEndDate);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[eta toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKETADataModel *eta1 = [[NestSDKETADataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKETADataModel *eta2 = [[NestSDKETADataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKETADataModel *eta3 = [[NestSDKETADataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                eta3.tripId = @"someTripId";

                expect(eta1.hash).to.equal(eta2.hash);
                expect(eta1.hash).notTo.equal(eta3.hash);

                expect(eta1).to.equal(eta2);
                expect(eta1).notTo.equal(eta3);
            });
        });
    }
SpecEnd