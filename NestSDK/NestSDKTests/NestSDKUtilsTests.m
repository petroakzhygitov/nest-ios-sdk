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

#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "NestSDKAccessToken.h"
#import "LSStubRequestDSL.h"
#import "LSNocilla.h"
#import "NestSDKUtils.h"

SpecBegin(NestSDKUtils)
    {
        describe(@"NestSDKUtils", ^{

            it(@"should convert ISO8601 date string to date", ^{
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

                NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour
                        | NSCalendarUnitMinute | NSCalendarUnitSecond;

                NSDate *date = [NestSDKUtils dateWithISO8601FormatDateString:@"2015-10-31T22:42:59.000Z"];
                NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
                expect(dateComponents.year).to.equal(2015);
                expect(dateComponents.month).to.equal(10);
                expect(dateComponents.day).to.equal(31);
                expect(dateComponents.hour).to.equal(22);
                expect(dateComponents.minute).to.equal(42);
                expect(dateComponents.second).to.equal(59);

                date = [NestSDKUtils dateWithISO8601FormatDateString:@"2008-12-31T23:59:59.000Z"];
                dateComponents = [calendar components:unitFlags fromDate:date];
                expect(dateComponents.year).to.equal(2008);
                expect(dateComponents.month).to.equal(12);
                expect(dateComponents.day).to.equal(31);
                expect(dateComponents.hour).to.equal(23);
                expect(dateComponents.minute).to.equal(59);
                expect(dateComponents.second).to.equal(59);
            });

            it(@"should convert date to ISO8601 date string", ^{
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateComponents.year = 2008;
                dateComponents.month = 12;
                dateComponents.day = 31;
                dateComponents.hour = 23;
                dateComponents.minute = 59;
                dateComponents.second = 59;

                NSDate *date = [calendar dateFromComponents:dateComponents];
                expect([NestSDKUtils iso8601FormatDateStringWithDate:date]).to.equal(@"2008-12-31T23:59:59.000Z");

                dateComponents = [[NSDateComponents alloc] init];
                dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                dateComponents.year = 2015;
                dateComponents.month = 10;
                dateComponents.day = 31;
                dateComponents.hour = 22;
                dateComponents.minute = 42;
                dateComponents.second = 59;

                date = [calendar dateFromComponents:dateComponents];
                expect([NestSDKUtils iso8601FormatDateStringWithDate:date]).to.equal(@"2015-10-31T22:42:59.000Z");
            });

            it(@"should equals objects", ^{
                NSString *string1 = @"someString";
                NSString *string2 = @"someString";
                NSString *string3 = @"someOtherString";

                expect([NestSDKUtils object:string1 isEqualToObject:string2]).to.equal(YES);
                expect([NestSDKUtils object:string1 isEqualToObject:string3]).to.equal(NO);
                expect([NestSDKUtils object:nil isEqualToObject:string2]).to.equal(NO);
                expect([NestSDKUtils object:string1 isEqualToObject:nil]).to.equal(NO);
                expect([NestSDKUtils object:nil isEqualToObject:nil]).to.equal(YES);
            });
        });
    }
SpecEnd