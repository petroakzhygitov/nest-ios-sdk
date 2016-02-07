#import <NestSDK/NestSDKCamera.h>
#import <NestSDK/NestSDKCameraLastEvent.h>
#import "CameraViewModel.h"


@implementation CameraViewModel
#pragma mark Override

- (NSString *)streamingStatusTitle {
    return @"Streaming:";
}

- (NSNumber *)streamingStatusValue {
    return @(self.device.isStreaming);
}

- (void)setStreamingStatusValue:(NSNumber *)value {
    self.device.isStreaming = value.boolValue;
}

- (NSString *)isAudioInputEnabledText {
    return [self stringWithTitle:@"Audio input enabled:" boolValue:self.device.isAudioInputEnabled];
}

- (NSString *)isVideoHistoryEnabledText {
    return [self stringWithTitle:@"Video history enabled:" boolValue:self.device.isVideoHistoryEnabled];
}

- (NSString *)lastIsOnlineChangeText {
    return [self stringWithTitle:@"Last online:" dateValue:self.device.lastIsOnlineChange];
}

- (NSString *)webURLText {
    return [self stringWithTitle:@"Web URL:" stringValue:self.device.webUrl];
}

- (NSString *)appURLText {
    return [self stringWithTitle:@"App URL:" stringValue:self.device.appUrl];
}

- (NSString *)lastEventText {
    return [self stringWithTitle:@"Last event:" dateValue:self.device.lastEvent.startTime];
}

@end