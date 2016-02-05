#import <Foundation/Foundation.h>
#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import "DeviceViewModel.h"
#import "SmokeCOAlarmIconView.h"

@protocol NestSDKSmokeCOAlarm;

@protocol SmokeCOAlarmViewModel <DeviceViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKSmokeCOAlarm> device;

@property(nonatomic, copy) NSString *batteryStatusText;

@property(nonatomic) SmokeCOAlarmIconViewColor iconViewColor;

@end


@interface SmokeCOAlarmViewModel : DeviceViewModel <SmokeCOAlarmViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKSmokeCOAlarm> device;

@property(nonatomic, copy) NSString *lastConnectionText;
@property(nonatomic, copy) NSString *localeText;
@end