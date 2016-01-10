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

// https://github.com/luisobo/Nocilla/issues/81
#undef andReturn

#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "Expecta.h"
#import "NestSDKAuthorizationManager.h"
#import "NestSDKError.h"
#import "NestSDKAccessToken.h"
#import "NestSDKAuthorizationManagerAuthorizationResult.h"
#import "LSStubRequestDSL.h"
#import "LSNocilla.h"

SpecBegin(NestSDKAuthorizationManager)
    {
        describe(@"NestSDKAuthorizationManager", ^{

            __block id mainBundleMock;

            beforeEach(^{
                mainBundleMock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
                [[[mainBundleMock stub] andReturn:@"NestProductID"] objectForInfoDictionaryKey:@"NestProductID"];
                [[[mainBundleMock stub] andReturn:@"NestProductSecret"] objectForInfoDictionaryKey:@"NestProductSecret"];
                [[[mainBundleMock stub] andReturn:@"NestRedirectURL"] objectForInfoDictionaryKey:@"NestRedirectURL"];
            });

            beforeAll(^{
                [[LSNocilla sharedInstance] start];
            });

            afterAll(^{
                [[LSNocilla sharedInstance] stop];
            });

            afterEach(^{
                [[LSNocilla sharedInstance] clearStubs];

                [mainBundleMock stopMocking];
            });

            it(@"should check view controller argument", ^{
                NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [authorizationManager authorizeWithNestAccountFromViewController:nil
                                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                                 expect(result).to.equal(nil);
                                                                                 expect(error.domain).to.equal(NestSDKErrorDomain);
                                                                                 expect(error.code).to.equal(NestSDKErrorCodeArgumentRequired);
                                                                                 done();
                                                                             }];
                });
            });

            it(@"should check NestProductID bundle key", ^{
                [mainBundleMock stopMocking];

                mainBundleMock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
                [[[mainBundleMock stub] andReturn:@"NestProductSecret"] objectForInfoDictionaryKey:@"NestProductSecret"];
                [[[mainBundleMock stub] andReturn:@"NestRedirectURL"] objectForInfoDictionaryKey:@"NestRedirectURL"];

                NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [authorizationManager authorizeWithNestAccountFromViewController:[[UIViewController alloc] init]
                                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                                 expect(result).to.equal(nil);
                                                                                 expect(error.domain).to.equal(NestSDKErrorDomain);
                                                                                 expect(error.code).to.equal(NestSDKErrorCodeMainBundleKeyRequired);
                                                                                 done();
                                                                             }];
                });
            });

            it(@"should check NestProductSecret bundle key", ^{
                [mainBundleMock stopMocking];

                mainBundleMock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
                [[[mainBundleMock stub] andReturn:@"NestProductID"] objectForInfoDictionaryKey:@"NestProductID"];
                [[[mainBundleMock stub] andReturn:@"NestRedirectURL"] objectForInfoDictionaryKey:@"NestRedirectURL"];

                NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [authorizationManager authorizeWithNestAccountFromViewController:[[UIViewController alloc] init]
                                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                                 expect(result).to.equal(nil);
                                                                                 expect(error.domain).to.equal(NestSDKErrorDomain);
                                                                                 expect(error.code).to.equal(NestSDKErrorCodeMainBundleKeyRequired);
                                                                                 done();
                                                                             }];
                });
            });

            it(@"should check NestRedirectURL bundle key", ^{
                [mainBundleMock stopMocking];

                mainBundleMock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
                [[[mainBundleMock stub] andReturn:@"NestProductID"] objectForInfoDictionaryKey:@"NestProductID"];
                [[[mainBundleMock stub] andReturn:@"NestProductSecret"] objectForInfoDictionaryKey:@"NestProductSecret"];

                NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [authorizationManager authorizeWithNestAccountFromViewController:[[UIViewController alloc] init]
                                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                                 expect(result).to.equal(nil);
                                                                                 expect(error.domain).to.equal(NestSDKErrorDomain);
                                                                                 expect(error.code).to.equal(NestSDKErrorCodeMainBundleKeyRequired);
                                                                                 done();
                                                                             }];
                });
            });

            it(@"should cancel by view controller", ^{
                id viewControllerMock = [OCMockObject mockForClass:[UIViewController class]];
                [[[viewControllerMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKAuthorizationViewController *authorizationViewController;
                    [invocation getArgument:&authorizationViewController atIndex:2];

                    [authorizationViewController.delegate hasCancelledAuthorization];

                }] presentViewController:[OCMArg any] animated:YES completion:[OCMArg any]];

                NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [authorizationManager authorizeWithNestAccountFromViewController:viewControllerMock
                                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                                 expect(error).to.equal(nil);
                                                                                 expect(result.isCancelled).to.equal(YES);
                                                                                 done();
                                                                             }];
                });
            });

            it(@"should fail with bad response", ^{
                id viewControllerMock = [OCMockObject mockForClass:[UIViewController class]];
                [[[viewControllerMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKAuthorizationViewController *authorizationViewController;
                    [invocation getArgument:&authorizationViewController atIndex:2];

                    [authorizationViewController.delegate hasReceivedAuthorizationCode:@"someCode"];

                }] presentViewController:[OCMArg any] animated:YES completion:[OCMArg any]];

                stubRequest(@"POST", @"https://api.home.nest.com/oauth2/access_token?code=someCode&client_id=NestProductID&client_secret=NestProductSecret&grant_type=authorization_code").
                        andReturn(403);

                NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [authorizationManager authorizeWithNestAccountFromViewController:viewControllerMock
                                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                                 expect(result).to.equal(nil);
                                                                                 expect(error.domain).to.equal(NestSDKErrorDomain);
                                                                                 expect(error.code).to.equal(NestSDKErrorCodeBadResponse);
                                                                                 done();
                                                                             }];
                });
            });

            it(@"should fail with bad json data", ^{
                id viewControllerMock = [OCMockObject mockForClass:[UIViewController class]];
                [[[viewControllerMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKAuthorizationViewController *authorizationViewController;
                    [invocation getArgument:&authorizationViewController atIndex:2];

                    [authorizationViewController.delegate hasReceivedAuthorizationCode:@"someCode"];

                }] presentViewController:[OCMArg any] animated:YES completion:[OCMArg any]];

                stubRequest(@"POST", @"https://api.home.nest.com/oauth2/access_token?code=someCode&client_id=NestProductID&client_secret=NestProductSecret&grant_type=authorization_code").
                        andReturn(200).withBody(@"bad_json_data");

                NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [authorizationManager authorizeWithNestAccountFromViewController:viewControllerMock
                                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                                 expect(result).to.equal(nil);
                                                                                 expect(error.domain).to.equal(NSCocoaErrorDomain);
                                                                                 expect(error.code).to.equal(3840);
                                                                                 done();
                                                                             }];
                });
            });

            it(@"should receive access token", ^{
                id viewControllerMock = [OCMockObject mockForClass:[UIViewController class]];
                [[[viewControllerMock stub] andDo:^(NSInvocation *invocation) {
                    [invocation retainArguments];

                    NestSDKAuthorizationViewController *authorizationViewController;
                    [invocation getArgument:&authorizationViewController atIndex:2];

                    [authorizationViewController.delegate hasReceivedAuthorizationCode:@"someCode"];

                }] presentViewController:[OCMArg any] animated:YES completion:[OCMArg any]];

                stubRequest(@"POST", @"https://api.home.nest.com/oauth2/access_token?code=someCode&client_id=NestProductID&client_secret=NestProductSecret&grant_type=authorization_code").
                        andReturn(200).withBody(@"{\"access_token\": \"qwerty\", \"expires_in\": 42""}");

                NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];

                waitUntil(^(DoneCallback done) {
                    [authorizationManager authorizeWithNestAccountFromViewController:viewControllerMock
                                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                                 expect(error).to.equal(nil);
                                                                                 expect(result.isCancelled).to.equal(NO);
                                                                                 expect(result.token.tokenString).to.equal(@"qwerty");
                                                                                 done();
                                                                             }];
                });
            });
        });
    }
SpecEnd