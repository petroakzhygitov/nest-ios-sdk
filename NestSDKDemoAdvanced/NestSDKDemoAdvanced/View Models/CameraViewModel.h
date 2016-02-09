#import <Foundation/Foundation.h>
#import "DeviceViewModel.h"


@protocol CameraViewModel <DeviceViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKCamera> device;

@property(nonatomic, readonly, copy) NSString *streamingStatusTitle;
@property(nonatomic) NSNumber *streamingStatusValue;

@property(nonatomic, readonly, copy) NSString *isAudioInputEnabledText;
@property(nonatomic, readonly, copy) NSString *isVideoHistoryEnabledText;

@property(nonatomic, readonly, copy) NSString *lastIsOnlineChangeText;

@property(nonatomic, readonly, copy) NSString *webURLText;
@property(nonatomic, readonly, copy) NSString *appURLText;

@property(nonatomic, readonly, copy) NSString *lastEventText;

@end


@interface CameraViewModel : DeviceViewModel <CameraViewModel>

@property(nonatomic) id <NestSDKCamera> device;

@end