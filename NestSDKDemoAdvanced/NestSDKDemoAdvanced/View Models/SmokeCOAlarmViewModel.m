#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import "SmokeCOAlarmViewModel.h"


@implementation SmokeCOAlarmViewModel
#pragma mark Private

- (NSString *)_alarmStateStringWithAlarmState:(NestSDKSmokeCOAlarmAlarmState)alarmState {
    switch (alarmState) {
        case NestSDKSmokeCOAlarmAlarmStateUndefined:
            return nil;

        case NestSDKSmokeCOAlarmAlarmStateOk:
            return @"OK";

        case NestSDKSmokeCOAlarmAlarmStateWarning:
            return @"Warning";

        case NestSDKSmokeCOAlarmAlarmStateEmergency:
            return @"Emergency";
    }

    return nil;
}


#pragma mark Override

- (NSString *)batteryHealthText {
    NSString *batteryHealthString = @"Undefined";

    switch (self.device.batteryHealth) {
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

- (NSString *)lastConnectionText {
    return [self stringWithDate:self.device.lastConnection];
}

- (NSString *)localeText {
    return self.device.locale;
}

- (NSString *)coAlarmStateText {
    return [self _alarmStateStringWithAlarmState:self.device.coAlarmState];

}

- (NSString *)smokeAlarmStateText {
    return [self _alarmStateStringWithAlarmState:self.device.smokeAlarmState];
}

- (NSString *)isManualStateActiveText {
    return [self stringWithBool:self.device.isManualTestActive];
}

- (NSString *)lastManualTestTimeText {
    return [self stringWithDate:self.device.lastManualTestTime];
}

- (NSString *)uiColorStateText {
    switch (self.device.uiColorState) {
        case NestSDKSmokeCOAlarmUIColorStateUndefined:
            return nil;

        case NestSDKSmokeCOAlarmUIColorStateGray:
            return @"Gray";

        case NestSDKSmokeCOAlarmUIColorStateGreen:
            return @"Green";

        case NestSDKSmokeCOAlarmUIColorStateYellow:
            return @"Yellow";

        case NestSDKSmokeCOAlarmUIColorStateRed:
            return @"Red";
    }

    return nil;
}


- (SmokeCOAlarmIconViewColor)iconViewColor {
    switch (self.device.uiColorState) {
        case NestSDKSmokeCOAlarmUIColorStateUndefined:
            return nil;

        case NestSDKSmokeCOAlarmUIColorStateGray:
            return SmokeCOAlarmIconViewColorGray;

        case NestSDKSmokeCOAlarmUIColorStateGreen:
            return SmokeCOAlarmIconViewColorGreen;

        case NestSDKSmokeCOAlarmUIColorStateYellow:
            return SmokeCOAlarmIconViewColorYellow;

        case NestSDKSmokeCOAlarmUIColorStateRed:
            return SmokeCOAlarmIconViewColorRed;
    }

    return nil;
}

@end