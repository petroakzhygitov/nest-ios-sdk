#import <Foundation/Foundation.h>

@class NestSDKAccessToken;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface NestSDKAccessTokenCache : NSObject
#pragma mark Properties

#pragma mark Methods

- (NestSDKAccessToken *)fetchAccessToken;

- (void)cacheAccessToken:(NestSDKAccessToken *)token;

- (void)clearCache;

@end