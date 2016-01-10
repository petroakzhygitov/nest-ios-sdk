#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKSmokeCoAlarm <NSObject>

@end


@interface NestSDKSmokeCOAlarm : JSONModel <NestSDKSmokeCoAlarm>
#pragma mark Properties

@property(nonatomic, copy) NSString <Optional> *battery_health;

@property(nonatomic, copy) NSString <Optional> *co_alarm_state;
@property(nonatomic, copy) NSString <Optional> *smoke_alarm_state;

@property(nonatomic) BOOL is_manual_test_active;

@property(nonatomic, copy) NSString <Optional> *last_manual_test_time;

@property(nonatomic, copy) NSString <Optional> *ui_color_state;

#pragma mark Methods

@end