#import <Foundation/Foundation.h>
#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import "DeviceViewModel.h"
#import "SmokeCOAlarmIconView.h"

@protocol NestSDKSmokeCOAlarm;

@protocol SmokeCOAlarmViewModel <DeviceViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKSmokeCOAlarm> device;

@property(nonatomic, readonly, copy) NSString *lastConnectionText;
@property(nonatomic, readonly, copy) NSString *localeText;

@property(nonatomic, readonly, copy) NSString *batteryStatusText;

@property(nonatomic, readonly, copy) NSString *coAlarmStateText;
@property(nonatomic, readonly, copy) NSString *smokeAlarmStateText;

@property(nonatomic, readonly, copy) NSString *isManualStateActiveText;
@property(nonatomic, readonly, copy) NSString *lastManualTestTimeText;

@property(nonatomic, readonly, copy) NSString *uiColorStateText;

@property(nonatomic) SmokeCOAlarmIconViewColor iconViewColor;

@end


@interface SmokeCOAlarmViewModel : DeviceViewModel <SmokeCOAlarmViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKSmokeCOAlarm> device;

@end