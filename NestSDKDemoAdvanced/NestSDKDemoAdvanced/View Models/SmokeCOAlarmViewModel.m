#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import "SmokeCOAlarmViewModel.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation SmokeCOAlarmViewModel {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

- (NSString *)_batteryHealthStringWithSmokeCOAlarm:(id <NestSDKSmokeCOAlarm>)smokeCOAlarm {
    NSString *batteryHealthString = @"Undefined";

    switch (smokeCOAlarm.batteryHealth) {
        case NestSDKSmokeCOAlarmBatteryHealthUndefined:
            batteryHealthString = @"Undefined";

            break;
        case NestSDKSmokeCOAlarmBatteryHealthOk:
            batteryHealthString = @"OK";

            break;
        case NestSDKSmokeCOAlarmBatteryHealthReplace:
            batteryHealthString = @"Replace";

            break;
    }

    return [NSString stringWithFormat:@"Battery health: %@", batteryHealthString];
}

+ (instancetype)viewModelWithSmokeCOAlarm:(id <NestSDKSmokeCOAlarm>)alarm {
    return nil;
}

- (UIColor *)_colorWithUIColorState:(NestSDKSmokeCOAlarmUIColorState)state {
    switch (state) {
        case NestSDKSmokeCOAlarmUIColorStateUndefined:
            return nil;

        case NestSDKSmokeCOAlarmUIColorStateGray:
            return [UIColor grayColor];

        case NestSDKSmokeCOAlarmUIColorStateGreen:
            return [UIColor greenColor];

        case NestSDKSmokeCOAlarmUIColorStateYellow:
            return [UIColor yellowColor];

        case NestSDKSmokeCOAlarmUIColorStateRed:
            return [UIColor redColor];
    }

    return nil;
}

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end