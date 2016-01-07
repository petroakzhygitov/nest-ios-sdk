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