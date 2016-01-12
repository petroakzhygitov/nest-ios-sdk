#import "NestSDKUtils.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation NestSDKUtils {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

+ (NSDateFormatter *)_iso8601DateFormatter {
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:enUSPOSIXLocale];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];

    return formatter;
}

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

+ (UIViewController *)viewControllerForView:(UIView *)view {
    UIResponder *responder = view.nextResponder;

    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) responder;
        }

        responder = responder.nextResponder;
    }

    return nil;
}

+ (NSDate *)dateWithISO8601FormatDateString:(NSString *)dateString {
    return [[self _iso8601DateFormatter] dateFromString:dateString];
}

+ (NSString *)iso8601FormatDateStringWithDate:(NSDate *)date {
    return [[self _iso8601DateFormatter] stringFromDate:date];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end