#import <Foundation/Foundation.h>
#import "SmokeCOAlarmIconView.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface SmokeCOAlarmViewModel : NSObject
#pragma mark Properties

@property(nonatomic, copy) NSString *nameLongText;

@property(nonatomic, copy) NSString *batteryStatusText;

@property(nonatomic) enum SmokeCOAlarmIconViewColor iconViewColor;

+ (instancetype)viewModelWithSmokeCOAlarm:(id <NestSDKSmokeCOAlarm>)alarm;

#pragma mark Methods

@end