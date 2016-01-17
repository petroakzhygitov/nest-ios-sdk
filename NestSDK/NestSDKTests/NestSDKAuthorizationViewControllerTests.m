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
#import "NestSDKAuthorizationManager.h"
#import "NestSDKError.h"

SpecBegin(NestSDKAuthorizationViewController)
    {
        describe(@"NestSDKAuthorizationViewController", ^{

            it(@"should fail with error without authorization URL", ^{
                waitUntil(^(DoneCallback done) {
                    NSURL *redirectURL = [NSURL URLWithString:@"https://example.com"];

                    id delegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKAuthorizationViewControllerDelegate)];
                    [[[delegateMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        NSError *error;
                        [invocation getArgument:&error atIndex:3];

                        expect(error.code).to.equal(NestSDKErrorCodeArgumentRequired);

                        done();

                    }] viewController:[OCMArg any] didFailWithError:[OCMArg any]];

                    NestSDKAuthorizationViewController *viewController = [[NestSDKAuthorizationViewController alloc] initWithAuthorizationURL:nil
                                                                                                                                  redirectURL:redirectURL
                                                                                                                                     delegate:delegateMock];
                });
            });

            it(@"should fail with error without redirect URL", ^{
                waitUntil(^(DoneCallback done) {
                    NSURL *authorizationURL = [NSURL URLWithString:@"https://example.com"];

                    id delegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKAuthorizationViewControllerDelegate)];
                    [[[delegateMock stub] andDo:^(NSInvocation *invocation) {
                        [invocation retainArguments];

                        NSError *error;
                        [invocation getArgument:&error atIndex:3];

                        expect(error.code).to.equal(NestSDKErrorCodeArgumentRequired);

                        done();

                    }] viewController:[OCMArg any] didFailWithError:[OCMArg any]];

                    NestSDKAuthorizationViewController *viewController = [[NestSDKAuthorizationViewController alloc] initWithAuthorizationURL:authorizationURL
                                                                                                                                  redirectURL:nil
                                                                                                                                     delegate:delegateMock];
                });
            });

            it(@"should cancel", ^{
                waitUntil(^(DoneCallback done) {
                    NSURL *authorizationURL = [NSURL URLWithString:@"https://authorization.com"];
                    NSURL *redirectURL = [NSURL URLWithString:@"https://example.com"];

                    id delegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKAuthorizationViewControllerDelegate)];
                    [[[delegateMock stub] andDo:^(NSInvocation *invocation) {
                        done();

                    }] viewControllerDidCancel:[OCMArg any]];

                    NestSDKAuthorizationViewController *viewController = [[NestSDKAuthorizationViewController alloc] initWithAuthorizationURL:authorizationURL
                                                                                                                                  redirectURL:redirectURL
                                                                                                                                     delegate:delegateMock];

                    [viewController performSelector:@selector(_cancelBarButtonItemPressed:) withObject:nil];
                });
            });

            it(@"should fail with wrong state", ^{
                waitUntil(^(DoneCallback done) {
                    NSURL *authorizationURL = [NSURL URLWithString:@"https://authorization.com/?state=goodState"];
                    NSURL *redirectURL = [NSURL URLWithString:@"https://example.com?state=12345"];

                    id delegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKAuthorizationViewControllerDelegate)];
                    [[[delegateMock stub] andDo:^(NSInvocation *anInvocation) {
                        [anInvocation retainArguments];

                        NSError *error;
                        [anInvocation getArgument:&error atIndex:3];

                        expect(error.code).to.equal(NestSDKErrorCodeInvalidURLParameter);

                        done();

                    }] viewController:[OCMArg any] didFailWithError:[OCMArg any]];

                    NestSDKAuthorizationViewController *viewController = [[NestSDKAuthorizationViewController alloc] initWithAuthorizationURL:authorizationURL
                                                                                                                                  redirectURL:redirectURL
                                                                                                                                     delegate:delegateMock];

                    UIWebViewNavigationType navigationType = UIWebViewNavigationTypeOther;
                    NSURLRequest *request = [NSURLRequest requestWithURL:redirectURL];

                    NSMethodSignature *signature = [NestSDKAuthorizationViewController instanceMethodSignatureForSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    [invocation setTarget:viewController];
                    [invocation setSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)];
                    [invocation setArgument:&request atIndex:3];
                    [invocation setArgument:&navigationType atIndex:4];
                    [invocation invoke];
                });
            });

            it(@"should fail with wrong code", ^{
                waitUntil(^(DoneCallback done) {
                    NSURL *authorizationURL = [NSURL URLWithString:@"https://authorization.com/?state=goodState"];
                    NSURL *redirectURL = [NSURL URLWithString:@"https://example.com?state=goodState&code="];

                    id delegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKAuthorizationViewControllerDelegate)];
                    [[[delegateMock stub] andDo:^(NSInvocation *anInvocation) {
                        [anInvocation retainArguments];

                        NSError *error;
                        [anInvocation getArgument:&error atIndex:3];

                        expect(error.code).to.equal(NestSDKErrorCodeInvalidURLParameter);

                        done();

                    }] viewController:[OCMArg any] didFailWithError:[OCMArg any]];

                    NestSDKAuthorizationViewController *viewController = [[NestSDKAuthorizationViewController alloc] initWithAuthorizationURL:authorizationURL
                                                                                                                                  redirectURL:redirectURL
                                                                                                                                     delegate:delegateMock];

                    UIWebViewNavigationType navigationType = UIWebViewNavigationTypeOther;
                    NSURLRequest *request = [NSURLRequest requestWithURL:redirectURL];

                    NSMethodSignature *signature = [NestSDKAuthorizationViewController instanceMethodSignatureForSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    [invocation setTarget:viewController];
                    [invocation setSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)];
                    [invocation setArgument:&request atIndex:3];
                    [invocation setArgument:&navigationType atIndex:4];
                    [invocation invoke];
                });
            });

            it(@"should receive authorization code", ^{
                waitUntil(^(DoneCallback done) {
                    NSURL *authorizationURL = [NSURL URLWithString:@"https://authorization.com/?state=goodState"];
                    NSURL *redirectURL = [NSURL URLWithString:@"https://example.com?state=goodState&code=42"];

                    id delegateMock = [OCMockObject mockForProtocol:@protocol(NestSDKAuthorizationViewControllerDelegate)];
                    [[[delegateMock stub] andDo:^(NSInvocation *anInvocation) {
                        [anInvocation retainArguments];

                        NSString *code;
                        [anInvocation getArgument:&code atIndex:3];

                        expect(code).to.equal(@"42");

                        done();

                    }] viewController:[OCMArg any] didReceiveAuthorizationCode:[OCMArg any]];

                    NestSDKAuthorizationViewController *viewController = [[NestSDKAuthorizationViewController alloc] initWithAuthorizationURL:authorizationURL
                                                                                                                                  redirectURL:redirectURL
                                                                                                                                     delegate:delegateMock];

                    UIWebViewNavigationType navigationType = UIWebViewNavigationTypeOther;
                    NSURLRequest *request = [NSURLRequest requestWithURL:redirectURL];

                    NSMethodSignature *signature = [NestSDKAuthorizationViewController instanceMethodSignatureForSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    [invocation setTarget:viewController];
                    [invocation setSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)];
                    [invocation setArgument:&request atIndex:3];
                    [invocation setArgument:&navigationType atIndex:4];
                    [invocation invoke];
                });
            });
        });
    }
SpecEnd