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
#import "NestSDKWheresDataModel.h"

SpecBegin(NestSDKMetadata)
    {
        describe(@"NestSDKMetadataDataModel", ^{
            
            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"metadata.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKMetadataDataModel *metadata = [[NestSDKMetadataDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                expect(metadata.accessToken).to.equal(@"c.FmDPkzyzaQe...");
                expect(metadata.clientVersion).to.equal(1);

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[metadata toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKMetadataDataModel *metadata1 = [[NestSDKMetadataDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKMetadataDataModel *metadata2 = [[NestSDKMetadataDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKMetadataDataModel *metadata3 = [[NestSDKMetadataDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                metadata3.clientVersion = 42;

                expect(metadata1.hash).to.equal(metadata2.hash);
                expect(metadata1.hash).notTo.equal(metadata3.hash);

                expect(metadata1).to.equal(metadata2);
                expect(metadata1).notTo.equal(metadata3);
            });
        });
    }
SpecEnd