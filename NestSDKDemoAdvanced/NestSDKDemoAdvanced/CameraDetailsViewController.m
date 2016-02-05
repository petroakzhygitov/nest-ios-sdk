#import "CameraDetailsViewController.h"
#import "CameraIconView.h"
#import "CameraViewModel.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation CameraDetailsViewController {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

- (void)addTitle {
    self.title = @"Camera";
}

- (void)addDeviceObservers {
    [self.dataManager observeCameraWithId:self.deviceViewModel.device.deviceId
                                    block:(NestSDKCameraUpdateHandler) self.deviceUpdateHandlerBlock];
}

- (void)updateTableViewHeader {
    [super updateTableViewHeader];

    self.nameLabel.text = self.deviceViewModel.nameLongText;

    self.iconView.streaming = self.deviceViewModel.streaming;
}

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end