#import "NestSDKAccessToken.h"//
//  NestSDKTests.m
//  NestSDKTests
//
//  Created by Petro Akzhygitov on 7/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <OCMock/OCMock.h>

// https://github.com/luisobo/Nocilla/issues/81
#undef andReturn


#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "Expecta.h"
#import "NestSDKAuthorizationManager.h"
#import "NestSDKError.h"
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