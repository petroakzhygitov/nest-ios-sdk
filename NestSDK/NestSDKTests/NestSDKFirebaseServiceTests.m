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
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "LSStubRequestDSL.h"
#import "LSNocilla.h"
#import <NestSDK/NestSDK.h>
#import <Expecta/Expecta.h>
#import <Firebase/Firebase.h>
#import "NestSDKFirebaseService.h"

SpecBegin(NestSDKFirebaseService)
    {
        describe(@"NestSDKFirebaseService", ^{

            it(@"should authenticate", ^{
                waitUntil(^(DoneCallback done) {
                    id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                    [[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        void (^block)(NSError *, FAuthData *);
                        [invocation getArgument:&block atIndex:3];

                        block(nil, nil);

                    }] authWithCustomToken:@"qwerty" withCompletionBlock:[OCMArg any]];

                    NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"qwerty" expirationDate:[NSDate distantFuture]];
                    NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];
                    [firebaseService authenticateWithAccessToken:accessToken completionBlock:^(NSError *error) {
                        expect(error).to.equal(nil);

                        done();
                    }];
                });
            });

            it(@"should not authenticate", ^{
                waitUntil(^(DoneCallback done) {
                    id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                    [[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        void (^block)(NSError *, FAuthData *);
                        [invocation getArgument:&block atIndex:3];

                        NSError *error = [NSError errorWithDomain:@"someDomain" code:1 userInfo:nil];
                        block(error, nil);

                    }] authWithCustomToken:@"qwerty" withCompletionBlock:[OCMArg any]];

                    NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"qwerty" expirationDate:[NSDate distantFuture]];
                    NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];
                    [firebaseService authenticateWithAccessToken:accessToken completionBlock:^(NSError *error) {
                        expect(error.domain).to.equal(@"someDomain");
                        expect(error.code).to.equal(1);

                        done();
                    }];
                });
            });

            it(@"should unauthenticate", ^{
                waitUntil(^(DoneCallback done) {
                    id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                    [[firebaseMock expect] removeAllObservers];

                    [[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        void (^block)(NSError *, FAuthData *);
                        [invocation getArgument:&block atIndex:3];

                        block(nil, nil);

                    }] authWithCustomToken:@"qwerty" withCompletionBlock:[OCMArg any]];

                    [[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                        [firebaseMock verify];

                        done();

                    }] unauth];

                    NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"qwerty" expirationDate:[NSDate distantFuture]];
                    NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];
                    [firebaseService authenticateWithAccessToken:accessToken completionBlock:^(NSError *error) {
                        expect(error).to.equal(nil);

                        [firebaseService unauthenticate];
                    }];
                });
            });

            it(@"should get values for url", ^{
                id fdataSnapshotMock = [OCMockObject mockForClass:[FDataSnapshot class]];
                [((FDataSnapshot *) [[fdataSnapshotMock stub] andReturn:@"someValue"]) value];

                id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                [[[firebaseMock stub] andReturn:firebaseMock] childByAppendingPath:@"someUrl"];
                [[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKServiceUpdateBlock block;
                    [invocation getArgument:&block atIndex:3];

                    block(fdataSnapshotMock, nil);

                }] observeSingleEventOfType:FEventTypeValue withBlock:[OCMArg any] withCancelBlock:[OCMArg any]];

                NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];

                waitUntil(^(DoneCallback done) {
                    [firebaseService valuesForURL:@"someUrl" withBlock:^(id result, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(result).to.equal(@"someValue");
                        done();
                    }];
                });
            });

            it(@"should not get values for url", ^{
                id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                [[[firebaseMock stub] andReturn:firebaseMock] childByAppendingPath:@"someUrl"];
                [[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    void (^cnacelBlock)(NSError *error);
                    [invocation getArgument:&cnacelBlock atIndex:4];

                    NSError *error = [NSError errorWithDomain:@"someDomain" code:42 userInfo:nil];
                    cnacelBlock(error);

                }] observeSingleEventOfType:FEventTypeValue withBlock:[OCMArg any] withCancelBlock:[OCMArg any]];

                NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];

                waitUntil(^(DoneCallback done) {
                    [firebaseService valuesForURL:@"someUrl" withBlock:^(id result, NSError *error) {
                        expect(result).to.equal(nil);
                        expect(error.domain).to.equal(@"someDomain");
                        expect(error.code).to.equal(42);
                        done();
                    }];
                });
            });

            it(@"should set values for url", ^{
                id fdataSnapshotMock = [OCMockObject mockForClass:[FDataSnapshot class]];
                [((FDataSnapshot *) [[fdataSnapshotMock stub] andReturn:@"someValue"]) value];

                id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                [[[firebaseMock stub] andReturn:firebaseMock] childByAppendingPath:@"someUrl"];
                [[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    void (^completionBlock)(NSError *error, BOOL committed, FDataSnapshot *snapshot);
                    [invocation getArgument:&completionBlock atIndex:3];

                    completionBlock(nil, NO, fdataSnapshotMock);

                }] runTransactionBlock:[OCMArg any] andCompletionBlock:[OCMArg any] withLocalEvents:NO];

                NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];

                waitUntil(^(DoneCallback done) {
                    [firebaseService setValues:@{@"some" : @"value"} forURL:@"someUrl" withBlock:^(id result, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(result).to.equal(@"someValue");
                        done();
                    }];
                });
            });

            it(@"should not set values for url", ^{
                id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                [[[firebaseMock stub] andReturn:firebaseMock] childByAppendingPath:@"someUrl"];
                [[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    void (^completionBlock)(NSError *error, BOOL committed, FDataSnapshot *snapshot);
                    [invocation getArgument:&completionBlock atIndex:3];

                    NSError *error = [NSError errorWithDomain:@"someDomain" code:42 userInfo:nil];
                    completionBlock(error, NO, nil);

                }] runTransactionBlock:[OCMArg any] andCompletionBlock:[OCMArg any] withLocalEvents:NO];

                NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];

                waitUntil(^(DoneCallback done) {
                    [firebaseService setValues:@{@"some" : @"value"} forURL:@"someUrl" withBlock:^(id result, NSError *error) {
                        expect(result).to.equal(nil);
                        expect(error.domain).to.equal(@"someDomain");
                        expect(error.code).to.equal(42);
                        done();
                    }];
                });
            });

            it(@"should observe values for url", ^{
                id fdataSnapshotMock = [OCMockObject mockForClass:[FDataSnapshot class]];
                [((FDataSnapshot *) [[fdataSnapshotMock stub] andReturn:@"someValue"]) value];

                id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                [[[firebaseMock stub] andReturn:firebaseMock] childByAppendingPath:@"someUrl"];
                [[[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    void (^block)(FDataSnapshot *snapshot);
                    [invocation getArgument:&block atIndex:3];

                    block(fdataSnapshotMock);

                }] andReturnValue:@(42)] observeEventType:FEventTypeValue withBlock:[OCMArg any] withCancelBlock:[OCMArg any]];

                NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];

                waitUntil(^(DoneCallback done) {
                    NestSDKObserverHandle handle = [firebaseService observeValuesForURL:@"someUrl" withBlock:^(id result, NSError *error) {
                        expect(error).to.equal(nil);
                        expect(result).to.equal(@"someValue");
                        done();
                    }];

                    expect(handle).to.equal(42);
                });
            });

            it(@"should not observe values for url", ^{
                id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                [[[firebaseMock stub] andReturn:firebaseMock] childByAppendingPath:@"someUrl"];
                [[[[firebaseMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    void (^block)(NSError *error);
                    [invocation getArgument:&block atIndex:4];

                    NSError *error = [NSError errorWithDomain:@"someDomain" code:42 userInfo:nil];
                    block(error);

                }] andReturnValue:@(44)] observeEventType:FEventTypeValue withBlock:[OCMArg any] withCancelBlock:[OCMArg any]];

                NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];

                waitUntil(^(DoneCallback done) {
                    NestSDKObserverHandle handle = [firebaseService observeValuesForURL:@"someUrl" withBlock:^(id result, NSError *error) {
                        expect(result).to.equal(nil);
                        expect(error.domain).to.equal(@"someDomain");
                        expect(error.code).to.equal(42);
                        done();
                    }];

                    expect(handle).to.equal(44);
                });
            });

            it(@"should remove observer with handler", ^{
                id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                [[firebaseMock expect] removeObserverWithHandle:42];

                NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];
                [firebaseService removeObserverWithHandle:42];

                [firebaseMock verify];
            });

            it(@"should remove all observers", ^{
                id firebaseMock = [OCMockObject mockForClass:[Firebase class]];
                [[firebaseMock expect] removeAllObservers];

                NestSDKFirebaseService *firebaseService = [[NestSDKFirebaseService alloc] initWithFirebase:firebaseMock];
                [firebaseService removeAllObservers];

                [firebaseMock verify];
            });

        });
    }
SpecEnd