#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>
#import <JSONModel/JSONModel.h>
#import "NestSDKDevice.h"

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKThermostat <NestSDKDevice>

@end


@interface NestSDKThermostat : NestSDKDevice <NestSDKThermostat>
#pragma mark Properties

@property(nonatomic) BOOL can_cool;
@property(nonatomic) BOOL can_heat;
@property(nonatomic) BOOL is_using_emergency_heat;
@property(nonatomic) BOOL has_fan;
@property(nonatomic) BOOL fan_timer_active;

@property(nonatomic, copy) NSString <Optional> *fan_timer_timeout;

@property(nonatomic) BOOL has_leaf;

@property(nonatomic, copy) NSString <Optional> *temperature_scale;

@property(nonatomic) NSUInteger target_temperature_f;
@property(nonatomic) CGFloat target_temperature_c;
@property(nonatomic) NSUInteger target_temperature_high_f;
@property(nonatomic) CGFloat target_temperature_high_c;
@property(nonatomic) NSUInteger target_temperature_low_f;
@property(nonatomic) CGFloat target_temperature_low_c;
@property(nonatomic) NSUInteger away_temperature_high_f;
@property(nonatomic) CGFloat away_temperature_high_c;
@property(nonatomic) NSUInteger away_temperature_low_f;
@property(nonatomic) CGFloat away_temperature_low_c;

@property(nonatomic, copy) NSString <Optional> *hvac_mode;

@property(nonatomic) CGFloat ambient_temperature_c;
@property(nonatomic) NSUInteger ambient_temperature_f;

@property(nonatomic) NSUInteger humidity;

@property(nonatomic, copy) NSString <Optional> *hvac_state;

#pragma mark Methods

@end