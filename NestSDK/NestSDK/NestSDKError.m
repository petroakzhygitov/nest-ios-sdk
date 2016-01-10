#import "NestSDKError.h"

#pragma mark macros

#pragma mark const

NSString *const NestSDKErrorDomain = @"NestSDKErrorDomain";

#pragma mark enum

#pragma mark typedef


@implementation NestSDKError {
#pragma mark Instance variables
}


#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

+ (NSString *)errorDomain {
    return NestSDKErrorDomain;
}

+ (NSError *)errorWithCode:(NSInteger)code
                  userInfo:(NSDictionary *)userInfo
                   message:(NSString *)message
           underlyingError:(NSError *)underlyingError {

    return [[NSError alloc] initWithDomain:[self errorDomain] code:code userInfo:userInfo];
}

+ (NSError *)argumentRequiredErrorWithName:(NSString *)name message:(NSString *)message {
    if (!message) {
        message = [[NSString alloc] initWithFormat:@"Value for %@ is required.", name];
    }

    return [self errorWithCode:NestSDKErrorCodeArgumentRequired
                      userInfo:nil
                       message:message
               underlyingError:nil];
}


+ (NSError *)mainBundleKeyRequiredErrorWithKey:(NSString *)key message:(NSString *)message {
    if (!message) {
        message = [[NSString alloc] initWithFormat:@"%@ key in main bundle is required. Check it is set in your info.plist file.", key];
    }

    return [self errorWithCode:NestSDKErrorCodeMainBundleKeyRequired
                      userInfo:nil
                       message:message
               underlyingError:nil];
}

+ (NSError *)badResponseErrorWithStatusCode:(NSInteger)statusCode message:(NSString *)message {
    if (!message) {
        message = [[NSString alloc] initWithFormat:@"Received wrong status code: %d", statusCode];
    }

    return [self errorWithCode:NestSDKErrorCodeBadResponse
                      userInfo:nil
                       message:message
               underlyingError:nil];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end