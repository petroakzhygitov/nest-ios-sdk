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

#import "NestSDKUtils.h"

@implementation NestSDKUtils
#pragma mark Private

+ (NSDateFormatter *)_iso8601DateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

    return formatter;
}

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

+ (BOOL)object:(id)object isEqualToObject:(id)other {
    if (object == other) {
        return YES;
    }

    if (!object || !other) {
        return NO;
    }

    return [object isEqual:other];
}


@end