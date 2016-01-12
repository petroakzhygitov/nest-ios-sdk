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
#import "NestSDKDataManager.h"
#import "NestSDKApplicationDelegate.h"
#import "NestSDKFirebaseService.h"
#import "NestSDKMetadata.h"
#import "NestSDKError.h"
#import "NestSDKStructure.h"

SpecBegin(NestSDKDataManager)
    {
        describe(@"NestSDKDataManager", ^{

            __block NSString *resourcePath;

            __block id firebaseServiceMock;
            __block id appDelegateMock;

            beforeAll(^{
                resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
            });

            beforeEach(^{
                firebaseServiceMock = [OCMockObject mockForClass:[NestSDKFirebaseService class]];

                appDelegateMock = [OCMockObject partialMockForObject:[NestSDKApplicationDelegate sharedInstance]];
                [[[appDelegateMock stub] andReturn:firebaseServiceMock] service];
            });

            afterEach(^{
                [firebaseServiceMock stopMocking];
                [appDelegateMock stopMocking];
            });

            it(@"should get metadata", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString* filePath = [resourcePath stringByAppendingPathComponent:@"metadata.json"];
                    
                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);
                    
                }] valuesForURL:@"/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
                [dataManager metadataWithBlock:^(NestSDKMetadata *metadata, NSError *error) {
                    expect(error).to.equal(nil);
                    expect(metadata.accessToken).to.equal(@"c.FmDPkzyzaQe...");
                    expect(metadata.clientVersion).to.equal(1);
                }];
            });

            it(@"should not get metadata", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    updateBlock(@"bad_dictionary", nil);

                }] valuesForURL:@"/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
                [dataManager metadataWithBlock:^(NestSDKMetadata *metadata, NSError *error) {
                    expect(metadata).to.equal(nil);
                    expect(error.domain).to.equal(NestSDKErrorDomain);
                    expect(error.code).to.equal(NestSDKErrorCodeUnexpectedArgumentType);
                }];
            });

            it(@"should get structures", ^{
                [[[firebaseServiceMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NSString* filePath = [resourcePath stringByAppendingPathComponent:@"structures.json"];

                    NestSDKServiceUpdateBlock updateBlock;
                    [invocation getArgument:&updateBlock atIndex:3];

                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

                    updateBlock(dictionary, nil);

                }] valuesForURL:@"/" withBlock:[OCMArg any]];

                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
                [dataManager structuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
                    expect(error).to.equal(nil);

                    NestSDKStructure *structure = structuresArray.firstObject;
                    expect(structure.structure_id).to.equal(@"VqFabWH21nwVyd4RWgJgNb292wa7hG_dUwo2i2SG7j3-BOLY0BA4sw");
                }];
            });

//            it(@"should get structures", ^{
//                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
//                [dataManager metaDataWithBlock:^() {
//
//                }];
//            });
//
//            it(@"should get thermostat", ^{
//                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
//                [dataManager metaDataWithBlock:^() {
//
//                }];
//            });
//
//            it(@"should get smoke co alarm", ^{
//                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
//                [dataManager metaDataWithBlock:^() {
//
//                }];
//            });
//
//            it(@"should get camera", ^{
//                NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
//                [dataManager metaDataWithBlock:^() {
//
//                }];
//            });
        });
    }
SpecEnd