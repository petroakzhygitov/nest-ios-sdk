#import "SmokeCOAlarmDetailsViewController.h"
#import "SmokeCOAlarmIconView.h"
#import "DeviceViewModel.h"
#import "SmokeCOAlarmViewModel.h"


@implementation SmokeCOAlarmDetailsViewController
#pragma mark Private

- (void)_addLocaleRow {
    self.localeRow = [self addReadOnlyTextRowWithTitle:@"Locale:" text:self.deviceViewModel.localeText];
}

- (void)_addLasConnectionRow {
    self.lastConnectionRow = [self addReadOnlyTextRowWithTitle:@"Last connection:" text:self.deviceViewModel.lastConnectionText];
}

- (void)_addBatteryHealthRow {
    self.batteryHealthRow = [self addReadOnlyTextRowWithTitle:@"Battery status:" text:self.deviceViewModel.batteryStatusText];
}


- (void)_addCOAlarmStateRow {

}

- (void)_addSmokeAlarmStateRow {

}

- (void)_addIsManualTestActiveRow {

}

- (void)_addLastManualTestTimeRow {

}

- (void)_addUIColorStateRow {

}

#pragma mark Override

- (void)addTitle {
    self.title = @"Protect";
}

- (void)addDeviceObservers {
    [self.dataManager observeSmokeCOAlarmWithId:self.deviceViewModel.device.deviceId
                                          block:(NestSDKSmokeCOAlarmUpdateHandler) self.deviceUpdateHandlerBlock];
}

- (void)updateTableViewHeader {
    [super updateTableViewHeader];

    self.nameLabel.text = self.deviceViewModel.nameLongText;

    self.iconView.color = self.deviceViewModel.iconViewColor;
}

- (void)addRows {
    [super addRows];

    [self _addLocaleRow];
    [self _addLasConnectionRow];

    [self _addBatteryHealthRow];

    [self _addCOAlarmStateRow];
    [self _addSmokeAlarmStateRow];

    [self _addIsManualTestActiveRow];
    [self _addLastManualTestTimeRow];

    [self _addUIColorStateRow];
}

@end