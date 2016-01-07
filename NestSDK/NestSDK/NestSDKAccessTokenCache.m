#import "NestSDKAccessTokenCache.h"
#import "NestSDKAccessToken.h"
#import "SSKeychain.h"

#pragma mark macros

#pragma mark const

static NSString *const kServiceName = @"NestSDKApplicationDelegate";
static NSString *const kAccountName = @"default";

#pragma mark enum

#pragma mark typedef


@implementation NestSDKAccessTokenCache {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

- (NestSDKAccessToken *)fetchAccessToken {
    NSData *archivedTokenData = [SSKeychain passwordDataForService:kServiceName account:kAccountName];
    if (!archivedTokenData.length) return nil;

    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedTokenData];
}

- (void)cacheAccessToken:(NestSDKAccessToken *)token {
    NSData *archivedTokenData = [NSKeyedArchiver archivedDataWithRootObject:token];

    if (!archivedTokenData.length) {
        [self clearCache];

    } else {
        [SSKeychain setPasswordData:archivedTokenData forService:kServiceName account:kAccountName];
    }
}

- (void)clearCache {
    [SSKeychain setPasswordData:[NSData data] forService:kServiceName account:kAccountName];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end