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
#import "NestSDKAccessTokenCache.h"
#import "NestSDKAccessToken.h"

SpecBegin(NestSDKAccessTokenCache)
    {
        describe(@"NestSDKAccessTokenCache", ^{

            it(@"should cache, fetch and clear access token cache", ^{
                NestSDKAccessTokenCache *cache = [[NestSDKAccessTokenCache alloc] init];
                [cache clearCache];

                expect(cache.fetchAccessToken).to.equal(nil);

                NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:@"someToken"
                                                                                   expirationDate:[NSDate dateWithTimeIntervalSince1970:42]];

                [cache cacheAccessToken:accessToken];
                expect(cache.fetchAccessToken).to.equal(accessToken);

                NestSDKAccessTokenCache *cache2 = [[NestSDKAccessTokenCache alloc] init];
                expect(cache2.fetchAccessToken).to.equal(accessToken);

                [cache2 clearCache];
                expect(cache2.fetchAccessToken).to.equal(nil);
                expect(cache.fetchAccessToken).to.equal(nil);
            });
        });
    }
SpecEnd