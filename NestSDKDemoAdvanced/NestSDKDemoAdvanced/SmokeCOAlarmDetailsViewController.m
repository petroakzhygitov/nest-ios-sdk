#import "SmokeCOAlarmDetailsViewController.h"
#import "SmokeCOAlarmIconView.h"
#import "DeviceViewModel.h"
#import "SmokeCOAlarmViewModel.h"


@implementation SmokeCOAlarmDetailsViewController

@dynamic tableView;
@dynamic deviceViewModel;

#pragma mark Private

- (void)_addLocaleRow {
    self.localeRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.localeText];
}

- (void)_addLasConnectionRow {
    self.lastConnectionRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.lastConnectionText];
}

- (void)_addBatteryHealthRow {
    self.batteryHealthRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.batteryStatusText];
}

- (void)_addCOAlarmStateRow {
    self.coAlarmStateRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.coAlarmStateText];
}

- (void)_addSmokeAlarmStateRow {
    self.smokeAlarmStateRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.smokeAlarmStateText];
}

- (void)_addIsManualTestActiveRow {
    self.isManualTestActiveRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.isManualStateActiveText];
}

- (void)_addLastManualTestTimeRow {
    self.lastManualTestTimeRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.lastManualTestTimeText];
}

- (void)_addUIColorStateRow {
    self.uiColorStateRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.uiColorStateText];
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

    self.nameLabel.text = self.deviceViewModel.nameLongValue;

    self.iconView.color = self.deviceViewModel.iconViewColor;
}

- (void)updateTableViewData {
    self.updatingTableViewData = YES;

    self.localeRow.value = self.deviceViewModel.localeText;
    self.lastConnectionRow.value = self.deviceViewModel.lastConnectionText;

    self.batteryHealthRow.value = self.deviceViewModel.batteryStatusText;

    self.coAlarmStateRow.value = self.deviceViewModel.coAlarmStateText;
    self.smokeAlarmStateRow.value = self.deviceViewModel.smokeAlarmStateText;

    self.isManualTestActiveRow.value = self.deviceViewModel.isManualStateActiveText;
    self.lastManualTestTimeRow.value = self.deviceViewModel.lastManualTestTimeText;

    self.uiColorStateRow.value = self.deviceViewModel.uiColorStateText;

    [super updateTableViewData];
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