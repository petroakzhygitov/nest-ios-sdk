#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import "SmokeCOAlarmViewModel.h"


@implementation SmokeCOAlarmViewModel

@synthesize device;

#pragma mark Private

- (NSString *)_stringWithTitle:(NSString *)title alarmStateValue:(NestSDKSmokeCOAlarmAlarmState)value {
    NSString *alarmState = [self _alarmStateStringWithAlarmState:value];

    return [self stringWithTitle:title stringValue:alarmState];
}

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

- (NSString *)_uiColorStateString {
    switch (self.device.uiColorState) {
        case NestSDKSmokeCOAlarmUIColorStateUndefined:
            return @"Undefined";

        case NestSDKSmokeCOAlarmUIColorStateGray:
            return @"Gray";

        case NestSDKSmokeCOAlarmUIColorStateGreen:
            return @"Green";

        case NestSDKSmokeCOAlarmUIColorStateYellow:
            return @"Yellow";

        case NestSDKSmokeCOAlarmUIColorStateRed:
            return @"Red";
    }

    return @"Undefined";
}

- (NSString *)_batteryHealthString {
    switch (self.device.batteryHealth) {
        case NestSDKSmokeCOAlarmBatteryHealthUndefined:
            return @"Undefined";

        case NestSDKSmokeCOAlarmBatteryHealthOk:
            return @"OK";

        case NestSDKSmokeCOAlarmBatteryHealthReplace:
            return @"Replace";
    }

    return @"Undefined";
}

#pragma mark Override

- (NSString *)localeText {
    return [self stringWithTitle:@"Locale:" stringValue:self.device.locale];
}

- (NSString *)lastConnectionText {
    return [self stringWithTitle:@"Last connection:" dateValue:self.device.lastConnection];
}

- (NSString *)coAlarmStateText {
    return [self _stringWithTitle:@"CO alarm state:" alarmStateValue:self.device.coAlarmState];
}

- (NSString *)smokeAlarmStateText {
    return [self _stringWithTitle:@"Smoke alarm state:" alarmStateValue:self.device.smokeAlarmState];
}

- (NSString *)isManualStateActiveText {
    return [self stringWithTitle:@"Manual state active:" boolValue:self.device.isManualTestActive];
}

- (NSString *)lastManualTestTimeText {
    return [self stringWithTitle:@"Last manual test:" dateValue:self.device.lastManualTestTime];
}

- (NSString *)batteryStatusText {
    NSString *batteryHealthString = [self _batteryHealthString];

    return [self stringWithTitle:@"Battery health:" stringValue:batteryHealthString];
}

- (NSString *)uiColorStateText {
    NSString *uiColorStateString = [self _uiColorStateString];

    return [self stringWithTitle:@"UI color:" stringValue:uiColorStateString];
}

- (SmokeCOAlarmIconViewColor)iconViewColor {
    switch (self.device.uiColorState) {
        case NestSDKSmokeCOAlarmUIColorStateUndefined:
            return SmokeCOAlarmIconViewColorUndefined;

        case NestSDKSmokeCOAlarmUIColorStateGray:
            return SmokeCOAlarmIconViewColorGray;

        case NestSDKSmokeCOAlarmUIColorStateGreen:
            return SmokeCOAlarmIconViewColorGreen;

        case NestSDKSmokeCOAlarmUIColorStateYellow:
            return SmokeCOAlarmIconViewColorYellow;

        case NestSDKSmokeCOAlarmUIColorStateRed:
            return SmokeCOAlarmIconViewColorRed;
    }

    return SmokeCOAlarmIconViewColorUndefined;
}

@end