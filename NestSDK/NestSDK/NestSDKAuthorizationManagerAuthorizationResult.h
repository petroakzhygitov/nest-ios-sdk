#import <Foundation/Foundation.h>

@class NestSDKAccessToken;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface NestSDKAuthorizationManagerAuthorizationResult : NSObject
#pragma mark Properties

@property(readonly, copy, nonatomic) NestSDKAccessToken *token;
@property(readonly, nonatomic) BOOL isCancelled;

#pragma mark Methods

- (instancetype)initWithToken:(NestSDKAccessToken *)token isCancelled:(BOOL)isCancelled NS_DESIGNATED_INITIALIZER;

@end