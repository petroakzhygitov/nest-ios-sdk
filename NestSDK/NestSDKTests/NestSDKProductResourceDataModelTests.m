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

SpecBegin(NestSDKProductResourceDataModel)
    {
        describe(@"NestSDKProductResourceDataModel", ^{

            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"product_resource.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKProductResourceDataModel *productResource = [[NestSDKProductResourceDataModel alloc] initWithData:data error:&error];
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

                dateComponents.minute = 02;
                dateComponents.second = 35;
                NSDate *measurementDate = [calendar dateFromComponents:dateComponents];

                expect(productResource.value).to.equal(50.2);
                expect(productResource.measurementTime).to.equal(measurementDate);
                expect(productResource.measurementResetTime).to.equal(measurementResetDate);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[productResource toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKProductResourceDataModel *productResource1 = [[NestSDKProductResourceDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductResourceDataModel *productResource2 = [[NestSDKProductResourceDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductResourceDataModel *productResource3 = [[NestSDKProductResourceDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                productResource3.value = 42.42;

                expect(productResource1.hash).to.equal(productResource2.hash);
                expect(productResource1.hash).notTo.equal(productResource3.hash);

                expect(productResource1).to.equal(productResource2);
                expect(productResource1).notTo.equal(productResource3);
            });

            it(@"should copy", ^{
                NSError *error;
                NestSDKProductResourceDataModel *productResource = [[NestSDKProductResourceDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductResourceDataModel *productResource2 = [productResource copy];
                expect(productResource).to.equal(productResource2);
            });
        });
    }
SpecEnd