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
#import "NestSDKProductLocationDataModel.h"

SpecBegin(NestSDKProductLocationDataModel)
    {
        describe(@"NestSDKProductLocationDataModel", ^{

            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"product_location.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKProductLocationDataModel *productLocation = [[NestSDKProductLocationDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                expect(productLocation.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");
                expect(productLocation.whereId).to.equal(@"d6reb_OZTM");

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[productLocation toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKProductLocationDataModel *productLocation1 = [[NestSDKProductLocationDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductLocationDataModel *productLocation2 = [[NestSDKProductLocationDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductLocationDataModel *productLocation3 = [[NestSDKProductLocationDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                productLocation3.structureId = @"someName";

                expect(productLocation1.hash).to.equal(productLocation2.hash);
                expect(productLocation1.hash).notTo.equal(productLocation3.hash);

                expect(productLocation1).to.equal(productLocation2);
                expect(productLocation1).notTo.equal(productLocation3);
            });

            it(@"should copy", ^{
                NSError *error;
                NestSDKProductLocationDataModel *productLocation = [[NestSDKProductLocationDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductLocationDataModel *productLocation2 = [productLocation copy];
                expect(productLocation).to.equal(productLocation2);
            });
        });
    }
SpecEnd