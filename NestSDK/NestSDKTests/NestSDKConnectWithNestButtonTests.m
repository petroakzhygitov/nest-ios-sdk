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
#import "Expecta.h"
#import "NestSDKAccessToken.h"
#import "NestSDKConnectWithNestButton.h"
#import "NestSDKAuthorizationManager.h"
#import "NestSDKAuthorizationManagerAuthorizationResult.h"

SpecBegin(NestSDKConnectWithNestButton)
    {
        describe(@"NestSDKConnectWithNestButton", ^{

            it(@"should change state depending on currentToken", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"someString"
                                                                                   expirationDate:[NSDate distantFuture]];
                [NestSDKAccessToken setCurrentAccessToken:accessToken];

                NestSDKConnectWithNestButton *connectWithNestButton = [[NestSDKConnectWithNestButton alloc] init];
                expect(connectWithNestButton.selected).to.equal(YES);

                [NestSDKAccessToken setCurrentAccessToken:nil];

                waitUntil(^(DoneCallback done) {
                    // Wait while button state update happen in main thread
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        expect(connectWithNestButton.selected).to.equal(NO);
                        done();
                    });
                });
            });

            it(@"should authorize with click", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"someString"
                                                                                   expirationDate:[NSDate distantFuture]];

                waitUntil(^(DoneCallback done) {
                    id authorizationManagerMock = [OCMockObject mockForClass:[NestSDKAuthorizationManager class]];
                    [[[authorizationManagerMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        NestSDKAuthorizationManagerAuthorizationHandler handler;
                        [invocation getArgument:&handler atIndex:3];

                        NestSDKAuthorizationManagerAuthorizationResult *result = [[NestSDKAuthorizationManagerAuthorizationResult alloc] initWithToken:accessToken
                                                                                                                                           isCancelled:NO];

                        handler(result, nil);

                    }] authorizeWithNestAccountFromViewController:[OCMArg any] handler:[OCMArg any]];

                    id connectWithNestButtonDelegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKConnectWithNestButtonDelegate)];
                    [[[connectWithNestButtonDelegateMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        NestSDKAuthorizationManagerAuthorizationResult *result;
                        [invocation getArgument:&result atIndex:3];

                        NSError *error;
                        [invocation getArgument:&error atIndex:4];

                        expect(error).to.equal(nil);
                        expect(result.isCancelled).to.equal(NO);
                        expect(result.token).to.equal(accessToken);

                        done();

                    }] connectWithNestButton:[OCMArg any] didAuthorizeWithResult:[OCMArg any] error:[OCMArg any]];

                    [[[connectWithNestButtonDelegateMock stub] andReturnValue:@YES] connectWithNestButtonWillAuthorize:[OCMArg any]];

                    NestSDKConnectWithNestButton *connectWithNestButton = [[NestSDKConnectWithNestButton alloc] init];
                    connectWithNestButton.delegate = connectWithNestButtonDelegateMock;
                    [connectWithNestButton setValue:authorizationManagerMock forKey:@"authorizationManager"];

//                    dispatch_async(dispatch_get_main_queue(), ^(void) {
//                        [connectWithNestButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//                    });

                    [connectWithNestButton performSelector:@selector(_buttonPressed:) withObject:nil];
                });
            });

            it(@"should not authorize with isCancelled", ^{
                waitUntil(^(DoneCallback done) {
                    id authorizationManagerMock = [OCMockObject mockForClass:[NestSDKAuthorizationManager class]];
                    [[[authorizationManagerMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        NestSDKAuthorizationManagerAuthorizationHandler handler;
                        [invocation getArgument:&handler atIndex:3];

                        NestSDKAuthorizationManagerAuthorizationResult *result = [[NestSDKAuthorizationManagerAuthorizationResult alloc] initWithToken:nil
                                                                                                                                           isCancelled:YES];

                        handler(result, nil);

                    }] authorizeWithNestAccountFromViewController:[OCMArg any] handler:[OCMArg any]];

                    id connectWithNestButtonDelegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKConnectWithNestButtonDelegate)];
                    [[[connectWithNestButtonDelegateMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        NestSDKAuthorizationManagerAuthorizationResult *result;
                        [invocation getArgument:&result atIndex:3];

                        NSError *error;
                        [invocation getArgument:&error atIndex:4];

                        expect(error).to.equal(nil);
                        expect(result.token).to.equal(nil);
                        expect(result.isCancelled).to.equal(YES);

                        done();

                    }] connectWithNestButton:[OCMArg any] didAuthorizeWithResult:[OCMArg any] error:[OCMArg any]];

                    [[[connectWithNestButtonDelegateMock stub] andReturnValue:@YES] connectWithNestButtonWillAuthorize:[OCMArg any]];

                    NestSDKConnectWithNestButton *connectWithNestButton = [[NestSDKConnectWithNestButton alloc] init];
                    connectWithNestButton.delegate = connectWithNestButtonDelegateMock;
                    [connectWithNestButton setValue:authorizationManagerMock forKey:@"authorizationManager"];

//                    dispatch_async(dispatch_get_main_queue(), ^(void) {
//                        [connectWithNestButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//                    });

                    [connectWithNestButton performSelector:@selector(_buttonPressed:) withObject:nil];
                });
            });

            it(@"should not authorize with error", ^{
                waitUntil(^(DoneCallback done) {
                    id authorizationManagerMock = [OCMockObject mockForClass:[NestSDKAuthorizationManager class]];
                    [[[authorizationManagerMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        NestSDKAuthorizationManagerAuthorizationHandler handler;
                        [invocation getArgument:&handler atIndex:3];

                        handler(nil, [NSError errorWithDomain:@"errorDomain" code:42 userInfo:nil]);

                    }] authorizeWithNestAccountFromViewController:[OCMArg any] handler:[OCMArg any]];

                    id connectWithNestButtonDelegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKConnectWithNestButtonDelegate)];
                    [[[connectWithNestButtonDelegateMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        NestSDKAuthorizationManagerAuthorizationResult *result;
                        [invocation getArgument:&result atIndex:3];

                        NSError *error;
                        [invocation getArgument:&error atIndex:4];

                        expect(error.domain).to.equal(@"errorDomain");
                        expect(error.code).to.equal(42);
                        expect(result.token).to.equal(nil);
                        expect(result.isCancelled).to.equal(NO);

                        done();

                    }] connectWithNestButton:[OCMArg any] didAuthorizeWithResult:[OCMArg any] error:[OCMArg any]];

                    [[[connectWithNestButtonDelegateMock stub] andReturnValue:@YES] connectWithNestButtonWillAuthorize:[OCMArg any]];

                    NestSDKConnectWithNestButton *connectWithNestButton = [[NestSDKConnectWithNestButton alloc] init];
                    connectWithNestButton.delegate = connectWithNestButtonDelegateMock;
                    [connectWithNestButton setValue:authorizationManagerMock forKey:@"authorizationManager"];

//                    dispatch_async(dispatch_get_main_queue(), ^(void) {
//                        [connectWithNestButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//                    });

                    [connectWithNestButton performSelector:@selector(_buttonPressed:) withObject:nil];
                });
            });
        });
    }
SpecEnd