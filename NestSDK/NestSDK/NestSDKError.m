#import "NestSDKError.h"

#pragma mark macros

#pragma mark const

NSString *const NestSDKErrorDomain = @"NestSDKErrorDomain";

static NSString *const kErrorDescriptionStingArgumentRequired = @"Method argument required error!";
static NSString *const kErrorDescriptionStingMainBundleKeyRequired = @"Main bundle key is required error!";
static NSString *const kErrorDescriptionStingBadResponse = @"Bad response received error!";
static NSString *const kErrorDescriptionStingUnexpectedType = @"Unexpected type of argument error!";
static NSString *const kErrorDescriptionStingUnableToParseData = @"Unable to parse data error!";

static NSString *const kErrorFailureReasonStingArgumentRequired = @"Value for '%@' is required.";
static NSString *const kErrorFailureReasonStingMainBundleKeyRequired = @"'%@' key in main bundle is required.";
static NSString *const kErrorFailureReasonStingBadResponse = @"Received wrong status code: %d";
static NSString *const kErrorFailureReasonStingUnexpectedType = @"Argument '%@' has unexpected type.";

static NSString *const kErrorRecoverySuggestionStingMainBundleKeyRequired = @"Check '%@' key is set in your info.plist file.";

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
               description:(NSString *)description
             failureReason:(NSString *)failureReason
        recoverySuggestion:(NSString *)recoverySuggestion
           underlyingError:(NSError *)underlyingError {

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[NSLocalizedDescriptionKey] = description;
    userInfo[NSLocalizedFailureReasonErrorKey] = failureReason;
    userInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion;
    userInfo[NSUnderlyingErrorKey] = underlyingError;

    return [[NSError alloc] initWithDomain:[self errorDomain] code:code userInfo:userInfo];
}

+ (NSError *)argumentRequiredErrorWithName:(NSString *)name message:(NSString *)message {
    return [self errorWithCode:NestSDKErrorCodeArgumentRequired
                   description:kErrorDescriptionStingArgumentRequired
                 failureReason:[NSString stringWithFormat:kErrorFailureReasonStingArgumentRequired, name]
            recoverySuggestion:nil
               underlyingError:nil];
}


+ (NSError *)mainBundleKeyRequiredErrorWithKey:(NSString *)key message:(NSString *)message {
    return [self errorWithCode:NestSDKErrorCodeMainBundleKeyRequired
                   description:kErrorDescriptionStingMainBundleKeyRequired
                 failureReason:[NSString stringWithFormat:kErrorFailureReasonStingMainBundleKeyRequired, key]
            recoverySuggestion:[NSString stringWithFormat:kErrorRecoverySuggestionStingMainBundleKeyRequired, key]
               underlyingError:nil];
}

+ (NSError *)badResponseErrorWithStatusCode:(NSInteger)statusCode message:(NSString *)message {
    return [self errorWithCode:NestSDKErrorCodeBadResponse
                   description:kErrorDescriptionStingBadResponse
                 failureReason:[NSString stringWithFormat:kErrorFailureReasonStingBadResponse, statusCode]
            recoverySuggestion:nil
               underlyingError:nil];
}

+ (NSError *)unexpectedArgumentTypeErrorWithName:(NSString *)name message:(NSString *)message {

    return [self errorWithCode:NestSDKErrorCodeUnexpectedArgumentType
                   description:kErrorDescriptionStingUnexpectedType
                 failureReason:[NSString stringWithFormat:kErrorFailureReasonStingUnexpectedType, name]
            recoverySuggestion:nil
               underlyingError:nil];
}

+ (NSError *)unableToParseDataErrorWithUnderlyingError:(NSError *)error {
    return [self errorWithCode:NestSDKErrorCodeUnableToParseData
                   description:kErrorDescriptionStingUnableToParseData
                 failureReason:nil
            recoverySuggestion:nil
               underlyingError:error];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end