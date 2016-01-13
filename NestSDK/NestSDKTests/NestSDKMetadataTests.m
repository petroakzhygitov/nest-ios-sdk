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
#import "NestSDKWheres.h"

SpecBegin(NestSDKWheres)
    {
        describe(@"NestSDKWheres", ^{
            
            __block NSData *wheresData;

            beforeAll(^{
                NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
                NSString *whereDataPath = [resourcePath stringByAppendingPathComponent:@"wheres.json"];

                wheresData = [NSData dataWithContentsOfFile:whereDataPath];
            });

            it(@"should deserialize/serialize wheres data", ^{
                NSError *error;
                NestSDKWheres *wheres = [[NestSDKWheres alloc] initWithData:wheresData error:&error];
                expect(error).to.equal(nil);

                expect(wheres.whereId).to.equal(@"Fqp6wJI...");
                expect(wheres.name).to.equal(@"Bedroom");
            });

            it(@"should have proper hash", ^{
                NSError *error;
                NestSDKWheres *wheres1 = [[NestSDKWheres alloc] initWithData:wheresData error:&error];
                expect(error).to.equal(nil);

                NestSDKWheres *wheres2 = [[NestSDKWheres alloc] initWithData:wheresData error:&error];
                expect(error).to.equal(nil);

                NestSDKWheres *wheres3 = [[NestSDKWheres alloc] initWithData:wheresData error:&error];
                wheres3.name = @"SomeName";
                expect(error).to.equal(nil);

                expect(wheres1.hash).to.equal(wheres2.hash);
                expect(wheres1.hash).notTo.equal(wheres3.hash);
            });

            it(@"should equal to another wheres", ^{
                NSError *error;
                NestSDKWheres *wheres1 = [[NestSDKWheres alloc] initWithData:wheresData error:&error];
                expect(error).to.equal(nil);

                NestSDKWheres *wheres2 = [[NestSDKWheres alloc] initWithData:wheresData error:&error];
                expect(error).to.equal(nil);

                NestSDKWheres *wheres3 = [[NestSDKWheres alloc] initWithData:wheresData error:&error];
                wheres3.name = @"SomeName";
                expect(error).to.equal(nil);

                expect(wheres1).to.equal(wheres2);
                expect(wheres1).notTo.equal(wheres3);
            });
        });
    }
SpecEnd