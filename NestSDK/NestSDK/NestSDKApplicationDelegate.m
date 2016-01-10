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

#import "NestSDKApplicationDelegate.h"
#import "NestSDKAccessToken.h"
#import "NestSDKAccessTokenCache.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation NestSDKApplicationDelegate {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

+ (instancetype)sharedInstance {
    static NestSDKApplicationDelegate *_sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Restoring cached token
    NestSDKAccessTokenCache *accessTokenCache = [[NestSDKAccessTokenCache alloc] init];
    NestSDKAccessToken *cachedToken = [accessTokenCache fetchAccessToken];

    // If expired then remove token
    if (!cachedToken || [[cachedToken expirationDate] compare:[NSDate date]] == NSOrderedAscending) {
        [accessTokenCache clearCache];

    } else {
        [NestSDKAccessToken setCurrentAccessToken:cachedToken];
    }

    return NO;
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end