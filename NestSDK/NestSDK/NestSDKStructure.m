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

#import "NestSDKDataModel.h"
#import "NestSDKStructure.h"
#import "NestSDKWheres.h"
#import "NestSDKUtils.h"

#pragma mark const

static NSString *const kAwayStringAway = @"away";
static NSString *const kAwayStringHome = @"home";
static NSString *const kAwayStringAutoAway = @"auto-away";


@implementation NestSDKStructure
#pragma mark Override

- (void)setPeakPeriodStartTimeWithNSString:(NSString *)peakPeriodStartTimeString {
    self.peakPeriodStartTime = [NestSDKUtils dateWithISO8601FormatDateString:peakPeriodStartTimeString];
}

- (id)JSONObjectForPeakPeriodStartTime {
    return [NestSDKUtils iso8601FormatDateStringWithDate:self.peakPeriodStartTime];
}

- (void)setPeakPeriodEndTimeTimeWithNSString:(NSString *)peakPeriodEndTimeString {
    self.peakPeriodEndTime = [NestSDKUtils dateWithISO8601FormatDateString:peakPeriodEndTimeString];
}

- (id)JSONObjectForPeakPeriodEndTime {
    return [NestSDKUtils iso8601FormatDateStringWithDate:self.peakPeriodEndTime];
}

- (void)setAwayWithNSString:(NSString *)awayString {
    if ([awayString isEqualToString:kAwayStringAway]) {
        self.away = NestSDKStructureAwayStateAway;

    } else if ([awayString isEqualToString:kAwayStringHome]) {
        self.away = NestSDKStructureAwayStateHome;

    } else if ([awayString isEqualToString:kAwayStringAutoAway]) {
        self.away = NestSDKStructureAwayStateAutoAway;
    }
}

- (id)JSONObjectForAway {
    switch (self.away) {
        case NestSDKStructureAwayStateUndefined:
            return nil;

        case NestSDKStructureAwayStateHome:
            return kAwayStringHome;

        case NestSDKStructureAwayStateAway:
            return kAwayStringAway;

        case NestSDKStructureAwayStateAutoAway:
            return kAwayStringAutoAway;
    }

    return nil;
}

@end