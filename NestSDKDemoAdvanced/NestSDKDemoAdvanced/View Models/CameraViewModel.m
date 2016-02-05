#import <NestSDK/NestSDKCamera.h>
#import "CameraViewModel.h"


@implementation CameraViewModel
#pragma mark Override

- (BOOL)streaming {
    return self.device.isStreaming;
}

- (NSString *)connectionStatusText {
    return [NSString stringWithFormat:@"Connection status: %@", self.device.isOnline ? @"Online" : @"Offline"];
}

@end