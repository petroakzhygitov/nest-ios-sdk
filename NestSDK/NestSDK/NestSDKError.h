#import <Foundation/Foundation.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

FOUNDATION_EXTERN NSString *const NestSDKErrorDomain;

/**
 * Error codes for NestSDKErrorDomain
 * @typedef NS_ENUM(NSInteger, NestSDKErrorCode)
 */
typedef NS_ENUM(NSInteger, FBSDKErrorCode) {
    /**
     *  Undefined.
     */
            NestSDKErrorCodeUnefined = 0,

    /**
     * The error code for errors from invalid arguments to SDK methods.
     */
            NestSDKErrorCodeArgumentRequired,

    /**
     * The error code for errors from invalid arguments to SDK methods.
     */
            NestSDKErrorCodeInvalidArgument,

    /**
     * The error code for errors from invalid arguments to SDK methods.
     */
            NestSDKErrorCodeMainBundleKeyRequired,

    /**
     * The error code for errors from invalid arguments to SDK methods.
     */
            NestSDKErrorCodeBadResponse,

    /**
     * The error code for errors from invalid arguments to SDK methods.
     */
            NestSDKErrorCodeUnexpectedArgumentType,

    /**
     * The error code for errors from invalid arguments to SDK methods.
     */
            NestSDKErrorCodeUnableToParseData
};

#pragma mark typedef

#pragma mark Protocol

@interface NestSDKError : NSObject
#pragma mark Properties

#pragma mark Methods

+ (NSError *)argumentRequiredErrorWithName:(NSString *)name message:(NSString *)message;

+ (NSError *)mainBundleKeyRequiredErrorWithKey:(NSString *)key message:(NSString *)message;

+ (NSError *)badResponseErrorWithStatusCode:(NSInteger)statusCode message:(NSString *)message;

+ (NSError *)unexpectedArgumentTypeErrorWithName:(NSString *)name message:(NSString *)message;

+ (NSError *)unableToParseDataErrorWithUnderlyingError:(NSError *)error;

@end