#import <Foundation/Foundation.h>
#import "DeviceViewModel.h"


@protocol CameraViewModel <DeviceViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKCamera> device;

@property(nonatomic, copy) NSString *connectionStatusText;

@property(nonatomic) BOOL streaming;

@end


@interface CameraViewModel : DeviceViewModel <CameraViewModel>

@end