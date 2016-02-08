#import "CameraDetailsViewController.h"
#import "CameraIconView.h"
#import "CameraViewModel.h"

@interface CameraDetailsViewController ()

@property(nonatomic, strong) XLFormRowDescriptor *isStreamingRow;

@property(nonatomic, strong) XLFormRowDescriptor *isAudioInputEnabledRow;
@property(nonatomic, strong) XLFormRowDescriptor *isVideoHistoryEnabledRow;

@property(nonatomic, strong) XLFormRowDescriptor *lastIsOnlineChangeRow;

@property(nonatomic, strong) XLFormRowDescriptor *webURLRow;
@property(nonatomic, strong) XLFormRowDescriptor *appURLRow;

@property(nonatomic, strong) XLFormRowDescriptor *lastEventRow;

@end

@implementation CameraDetailsViewController
#pragma mark Private

- (void)_addIsStreamingRow {
    self.isStreamingRow = [self addReadWriteSwitchRowWithTitle:self.deviceViewModel.streamingStatusTitle
                                                     boolValue:self.deviceViewModel.streamingStatusValue.boolValue];
}

- (void)_addIsAudioInputEnabled {
    self.isAudioInputEnabledRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.isAudioInputEnabledText];
}

- (void)_addLastIsOnlineChangeRow {
    self.lastIsOnlineChangeRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.lastIsOnlineChangeText];
}

- (void)_addIsVideoHistoryEnabledRow {
    self.isVideoHistoryEnabledRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.isVideoHistoryEnabledText];
}

- (void)_addWebUrlRow {
    self.webURLRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.webURLText];
}

- (void)_addAppUrlRow {
    self.appURLRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.appURLText];
}

- (void)_addLastEventRow {
    self.lastEventRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.lastEventText];
}

#pragma mark Override

- (void)addTitle {
    self.title = @"Camera";
}

- (void)addDeviceObservers {
    [self.dataManager observeCameraWithId:self.deviceViewModel.device.deviceId
                                    block:(NestSDKCameraUpdateHandler) self.deviceUpdateHandlerBlock];
}

- (void)updateDeviceViewModelData {
    self.deviceViewModel.streamingStatusValue = self.isStreamingRow.value;
}

- (void)updateDeviceData {
    [self.dataManager setCamera:self.deviceViewModel.device
                          block:(NestSDKCameraUpdateHandler) self.deviceUpdateHandlerBlock];
}

- (void)updateTableViewHeader {
    [super updateTableViewHeader];

    self.nameLabel.text = self.deviceViewModel.nameLongValue;

    self.iconView.streaming = self.deviceViewModel.streamingStatusValue.boolValue;
}

- (void)updateTableViewData {
    self.updatingTableViewData = YES;

    self.isStreamingRow.value = self.deviceViewModel.streamingStatusValue;

    self.isAudioInputEnabledRow.value = self.deviceViewModel.isAudioInputEnabledText;
    self.isVideoHistoryEnabledRow.value = self.deviceViewModel.isVideoHistoryEnabledText;

    self.lastIsOnlineChangeRow.value = self.deviceViewModel.lastIsOnlineChangeText;

    self.webURLRow.value = self.deviceViewModel.webURLText;
    self.appURLRow.value = self.deviceViewModel.appURLText;

    self.lastEventRow.value = self.deviceViewModel.lastEventText;

    [super updateTableViewData];
}

- (void)addRows {
    [super addRows];

    [self _addIsStreamingRow];

    [self _addIsAudioInputEnabled];

    [self _addLastIsOnlineChangeRow];
    [self _addIsVideoHistoryEnabledRow];

    [self _addWebUrlRow];
    [self _addAppUrlRow];

    [self _addLastEventRow];
}

@end