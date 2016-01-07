#import "NestSDKAuthorizationManagerAuthorizationResult.h"
#import "NestSDKAccessToken.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation NestSDKAuthorizationManagerAuthorizationResult {
#pragma mark Instance variables
}

#pragma mark Initializer

- (instancetype)initWithToken:(NestSDKAccessToken *)token isCancelled:(BOOL)isCancelled {
    self = [super init];
    if (self) {
        _token = token;
        _isCancelled = isCancelled;
    }

    return self;
}

- (instancetype)init {
    return [self initWithToken:nil isCancelled:NO];
}

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end