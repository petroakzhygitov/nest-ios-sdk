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
#import "LSStubRequestDSL.h"
#import "LSNocilla.h"
#import "NestSDKAccessToken.h"

SpecBegin(NestSDKAccessToken)
    {
        describe(@"NestSDKAccessToken", ^{
            it(@"should init", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                   expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                expect(accessToken.tokenString).to.equal(@"someToken");
                expect(accessToken.expirationDate).to.equal([NSDate dateWithTimeIntervalSince1970:42]);
            });

            it(@"should equal", ^{
                NestSDKAccessToken *accessToken1 = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                NestSDKAccessToken *accessToken2 = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                NestSDKAccessToken *accessToken3 = accessToken1;

                NestSDKAccessToken *accessToken4 = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:44]];

                NestSDKAccessToken *accessToken5 = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken2"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                expect(accessToken1).to.equal(accessToken2);
                expect(accessToken1).to.equal(accessToken3);
                expect(accessToken1).notTo.equal(accessToken4);
                expect(accessToken1).notTo.equal(accessToken5);

                expect([accessToken1 isEqualToAccessToken:accessToken2]).to.equal(YES);
                expect([accessToken1 isEqualToAccessToken:accessToken3]).to.equal(YES);
                expect([accessToken1 isEqualToAccessToken:accessToken4]).to.equal(NO);
                expect([accessToken1 isEqualToAccessToken:accessToken5]).to.equal(NO);
            });

            it(@"should have proper hash", ^{
                NestSDKAccessToken *accessToken1 = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                NestSDKAccessToken *accessToken2 = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                NestSDKAccessToken *accessToken3 = accessToken1;

                NestSDKAccessToken *accessToken4 = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:44]];

                NestSDKAccessToken *accessToken5 = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken2"
                                                                                    expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                expect(accessToken1.hash).to.equal(accessToken2.hash);
                expect(accessToken1.hash).to.equal(accessToken3.hash);
                expect(accessToken1.hash).notTo.equal(accessToken4.hash);
                expect(accessToken1.hash).notTo.equal(accessToken5.hash);
            });

            it(@"should set and get current access token", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                   expirationDate:[NSDate distantFuture]];

                expect([NestSDKAccessToken currentAccessToken]).to.equal(nil);

                [NestSDKAccessToken setCurrentAccessToken:accessToken];
                expect([NestSDKAccessToken currentAccessToken]).to.equal(accessToken);

                [NestSDKAccessToken setCurrentAccessToken:nil];
                expect([NestSDKAccessToken currentAccessToken]).to.equal(nil);
            });

            it(@"should archive and unarchive", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                   expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                NSData *archivedTokenData = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
                NestSDKAccessToken *unarchivedAccessToken = [NSKeyedUnarchiver unarchiveObjectWithData:archivedTokenData];

                expect(accessToken).to.equal(unarchivedAccessToken);
            });

            it(@"should send notifications", ^{
                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                   expirationDate:[NSDate distantFuture]];

                waitUntil(^(DoneCallback done) {
                    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NestSDKAccessTokenDidChangeNotification
                                                                                    object:nil
                                                                                     queue:nil
                                                                                usingBlock:^(NSNotification *notification) {
                                                                                    expect(notification.userInfo[NestSDKAccessTokenChangeNewKey]).to.equal(accessToken);
                                                                                    expect(notification.userInfo[NestSDKAccessTokenChangeOldKey]).to.equal(nil);

                                                                                    done();
                                                                                }];

                    [NestSDKAccessToken setCurrentAccessToken:accessToken];

                    [[NSNotificationCenter defaultCenter] removeObserver:observer];
                });

                waitUntil(^(DoneCallback done) {
                    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NestSDKAccessTokenDidChangeNotification
                                                                                    object:nil
                                                                                     queue:nil
                                                                                usingBlock:^(NSNotification *notification) {
                                                                                    expect(notification.userInfo[NestSDKAccessTokenChangeNewKey]).to.equal(nil);
                                                                                    expect(notification.userInfo[NestSDKAccessTokenChangeOldKey]).to.equal(accessToken);

                                                                                    done();
                                                                                }];

                    [NestSDKAccessToken setCurrentAccessToken:nil];

                    [[NSNotificationCenter defaultCenter] removeObserver:observer];
                });
            });
        });
    }
SpecEnd