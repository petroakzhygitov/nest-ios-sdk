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

SpecBegin(NestSDKWheres)
    {
        describe(@"NestSDKWheresDataModel", ^{
            
            __block NSData *data;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"wheres.json"];

                data = [NSData dataWithContentsOfFile:dataPath];
            });

            it(@"should deserialize/serialize data", ^{
                NSError *error;
                NestSDKWheresDataModel *wheres = [[NestSDKWheresDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                expect(wheres.whereId).to.equal(@"Fqp6wJI...");
                expect(wheres.name).to.equal(@"Bedroom");

                NSDictionary *serializedDictionary = [NSJSONSerialization JSONObjectWithData:[wheres toJSONData] options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                NSDictionary *initialDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                expect(error).to.equal(nil);

                expect(serializedDictionary).to.equal(initialDictionary);
            });

            it(@"should have proper hash and equal", ^{
                NSError *error;
                NestSDKWheresDataModel *wheres1 = [[NestSDKWheresDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKWheresDataModel *wheres2 = [[NestSDKWheresDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                NestSDKWheresDataModel *wheres3 = [[NestSDKWheresDataModel alloc] initWithData:data error:&error];
                expect(error).to.equal(nil);

                wheres3.name = @"SomeName";

                expect(wheres1.hash).to.equal(wheres2.hash);
                expect(wheres1.hash).notTo.equal(wheres3.hash);

                expect(wheres1).to.equal(wheres2);
                expect(wheres1).notTo.equal(wheres3);
            });
        });
    }
SpecEnd