#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>
#import <JSONModel/JSONModel.h>

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface NestSDKThermostat : JSONModel
#pragma mark Properties

@property(nonatomic, copy) NSString <Optional> *device_id;
@property(nonatomic, copy) NSString <Optional> *where_id;
@property(nonatomic, copy) NSString <Optional> *structure_id;
@property(nonatomic, copy) NSString <Optional> *name;
@property(nonatomic, copy) NSString <Optional> *name_long;
@property(nonatomic, copy) NSString <Optional> *locale;
@property(nonatomic, copy) NSString <Optional> *software_version;
@property(nonatomic, copy) NSString <Optional> *temperature_scale;

@property(nonatomic) BOOL is_using_emergency_heat;
@property(nonatomic) BOOL fan_timer_active;
@property(nonatomic) BOOL is_online;
@property(nonatomic) BOOL has_fan;
@property(nonatomic) BOOL has_leaf;
@property(nonatomic) BOOL can_heat;
@property(nonatomic) BOOL can_cool;

@property(nonatomic, copy) NSString <Optional> *hvac_mode;
@property(nonatomic, copy) NSString <Optional> *hvac_state;

@property(nonatomic) NSUInteger humidity;

@property(nonatomic) CGFloat target_temperature_c;
@property(nonatomic) NSUInteger target_temperature_f;
@property(nonatomic) CGFloat target_temperature_high_c;
@property(nonatomic) NSUInteger target_temperature_high_f;
@property(nonatomic) CGFloat target_temperature_low_c;
@property(nonatomic) NSUInteger target_temperature_low_f;
@property(nonatomic) CGFloat ambient_temperature_c;
@property(nonatomic) NSUInteger ambient_temperature_f;
@property(nonatomic) CGFloat away_temperature_high_c;
@property(nonatomic) NSUInteger away_temperature_high_f;
@property(nonatomic) CGFloat away_temperature_low_c;
@property(nonatomic) NSUInteger away_temperature_low_f;

#pragma mark Methods

@end