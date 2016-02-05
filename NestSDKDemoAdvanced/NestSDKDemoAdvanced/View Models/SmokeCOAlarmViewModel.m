#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import "SmokeCOAlarmViewModel.h"


@implementation SmokeCOAlarmViewModel
#pragma mark Override

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

- (NSString *)batteryStatusText {
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

@end