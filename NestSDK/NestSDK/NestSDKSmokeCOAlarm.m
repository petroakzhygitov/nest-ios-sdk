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

#import "NestSDKSmokeCOAlarm.h"
#import "NestSDKUtils.h"


@implementation NestSDKSmokeCOAlarm
#pragma mark Override

- (void)setLastConnectionWithNSString:(NSString *)peakPeriodStartTimeString {
    self.lastConnection = [NestSDKUtils dateWithISO8601FormatDateString:peakPeriodStartTimeString];
}

- (id)JSONObjectForLastConnection {
    return [NestSDKUtils iso8601FormatDateStringWithDate:self.lastConnection];
}

- (void)setLastManualTestTimeWithNSString:(NSString *)lastManualTestTimeString {
    self.lastManualTestTime = [NestSDKUtils dateWithISO8601FormatDateString:lastManualTestTimeString];
}

- (id)JSONObjectForLastManualTestTime {
    return [NestSDKUtils iso8601FormatDateStringWithDate:self.lastManualTestTime];
}


- (NSUInteger)hash {
    NSUInteger intValueForYes = 1231;
    NSUInteger intValueForNo = 1237;

    NSUInteger prime = 31;
    NSUInteger result = [super hash];

    result = prime * result + self.lastConnection.hash;
    result = prime * result + self.locale.hash;

    result = prime * result + self.batteryHealth;
    result = prime * result + self.coAlarmState;
    result = prime * result + self.smokeAlarmState;

    result = prime * result + (self.isManualTestActive ? intValueForYes : intValueForNo);

    result = prime * result + self.lastManualTestTime.hash;

    result = prime * result + self.uiColorState;

    return result;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;

    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    if (![super isEqual:other])
        return NO;

    NestSDKSmokeCOAlarm *otherSmokeCOAlarm = (NestSDKSmokeCOAlarm *) other;
    return (([NestSDKUtils object:self.lastConnection isEqualToObject:otherSmokeCOAlarm.lastConnection]) &&
            ([NestSDKUtils object:self.locale isEqualToObject:otherSmokeCOAlarm.locale]) &&
            (self.batteryHealth == otherSmokeCOAlarm.batteryHealth) &&
            (self.coAlarmState == otherSmokeCOAlarm.coAlarmState) &&
            (self.smokeAlarmState == otherSmokeCOAlarm.smokeAlarmState) &&
            (self.isManualTestActive == otherSmokeCOAlarm.isManualTestActive) &&
            ([NestSDKUtils object:self.lastManualTestTime isEqualToObject:otherSmokeCOAlarm.lastManualTestTime]) &&
            (self.uiColorState == otherSmokeCOAlarm.uiColorState));
}

@end