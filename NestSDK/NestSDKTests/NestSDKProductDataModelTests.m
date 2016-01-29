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
#import "NestSDKProductDataModel.h"

SpecBegin(NestSDKProductDataModel)
    {
        describe(@"NestSDKProductDataModel", ^{

            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"product.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKProductDataModel *product = [[NestSDKProductDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                expect(product.identification.deviceId).to.equal(@"CPMEMSnC48JlSAHjQIp-kHI72IjLYHK_ul_c54UFb8CmPXNj4ixLbg");
                expect(product.identification.serialNumber).to.equal(@"SN 2AZQQ01AZ423545Z7");
                expect(product.software.version).to.equal(@"v8.0.1rc3");
                expect(product.location.structureId).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");
                expect(product.resourceUse.electricity.value).to.equal(50.2);
                expect(product.resourceUse.gas.value).to.equal(42.7);
                expect(product.resourceUse.water.value).to.equal(123.7);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[product toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKProductDataModel *product1 = [[NestSDKProductDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductDataModel *product2 = [[NestSDKProductDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKProductDataModel *product3 = [[NestSDKProductDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                product3.identification.deviceId = @"someName";

                expect(product1.hash).to.equal(product2.hash);
                expect(product1.hash).notTo.equal(product3.hash);

                expect(product1).to.equal(product2);
                expect(product1).notTo.equal(product3);
            });
        });
    }
SpecEnd