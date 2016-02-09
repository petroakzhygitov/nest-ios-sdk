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
#import "NestSDKProductResourceDataModel.h"
#import "NestSDKProductResourceUseDataModel.h"

SpecBegin(NestSDKProductResourceUseDataModel)
    {
        describe(@"NestSDKProductResourceUseDataModel", ^{

            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"product_resource_use.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKProductResourceUseDataModel *productResourceUse = [[NestSDKProductResourceUseDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateComponents.year = 2015;
                dateComponents.month = 01;
                dateComponents.day = 01;
                dateComponents.hour = 01;
                dateComponents.minute = 01;
                dateComponents.second = 01;

                NSDate *measurementResetDate = [calendar dateFromComponents:dateComponents];

                expect(productResourceUse.electricity.value).to.equal(50.2);
                expect(productResourceUse.electricity.measurementResetTime).to.equal(measurementResetDate);
                expect(productResourceUse.water.value).to.equal(123.7);
                expect(productResourceUse.water.measurementResetTime).to.equal(measurementResetDate);
                expect(productResourceUse.gas.value).to.equal(42.7);
                expect(productResourceUse.gas.measurementResetTime).to.equal(measurementResetDate);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[productResourceUse toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKProductResourceUseDataModel *productResourceUse1 = [[NestSDKProductResourceUseDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductResourceUseDataModel *productResourceUse2 = [[NestSDKProductResourceUseDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductResourceUseDataModel *productResourceUse3 = [[NestSDKProductResourceUseDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                productResourceUse3.electricity.value = 42.42;

                expect(productResourceUse1.hash).to.equal(productResourceUse2.hash);
                expect(productResourceUse1.hash).notTo.equal(productResourceUse3.hash);

                expect(productResourceUse1).to.equal(productResourceUse2);
                expect(productResourceUse1).notTo.equal(productResourceUse3);
            });

            it(@"should copy", ^{
                NSError *error;
                NestSDKProductResourceUseDataModel *productResourceUse = [[NestSDKProductResourceUseDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductResourceUseDataModel *productResourceUse2 = [productResourceUse copy];
                expect(productResourceUse).to.equal(productResourceUse2);
            });
        });
    }
SpecEnd