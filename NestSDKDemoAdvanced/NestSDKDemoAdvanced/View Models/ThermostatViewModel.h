#import <Foundation/Foundation.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKDevice.h>
#import "ThermostatIconView.h"
#import "DeviceViewModel.h"

@protocol NestSDKThermostat;

@protocol ThermostatViewModel <DeviceViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKThermostat> device;

@property(nonatomic, readonly) ThermostatIconViewState iconViewState;

@property(nonatomic, readonly, copy) NSString *localeText;
@property(nonatomic, readonly, copy) NSString *lastConnectionText;

@property(nonatomic, readonly, copy) NSString *targetTemperatureHighTitle;
@property(nonatomic) NSNumber *targetTemperatureHighValue;

@property(nonatomic, readonly, copy) NSString *targetTemperatureLowTitle;
@property(nonatomic) NSNumber *targetTemperatureLowValue;

@property(nonatomic, readonly, copy) NSString *targetTemperatureTitle;
@property(nonatomic) NSNumber *targetTemperatureValue;

@property(nonatomic, readonly, copy) NSString *fanTimerActiveTitle;
@property(nonatomic) NSNumber *fanTimerActiveValue;

@property(nonatomic, readonly, copy) NSString *fanTimerTimeoutText;

@property(nonatomic, readonly, copy) NSString *hasFanText;
@property(nonatomic, readonly) NSNumber *hasFanValue;

@property(nonatomic, readonly, copy) NSString *hasLeafText;
@property(nonatomic, readonly) NSNumber *hasLeafValue;

@property(nonatomic, readonly, copy) NSString *temperatureScaleText;

@property(nonatomic, readonly, copy) NSString *isCoolingText;
@property(nonatomic, readonly, copy) NSString *isHeatingText;
@property(nonatomic, readonly, copy) NSString *isUsingEmergencyHeatText;

@property(nonatomic, readonly, copy) NSString *awayTemperatureHighText;
@property(nonatomic, readonly, copy) NSString *awayTemperatureLowText;

@property(nonatomic, readonly, copy) NSString *ambientTemperatureText;
@property(nonatomic, readonly, copy) NSString *humidityText;
@property(nonatomic, readonly, copy) NSString *hvacStateText;

@property(nonatomic, readonly, copy) NSString *hvacModeTitle;
@property(nonatomic, copy) NSString *hvacModeText;

#pragma mark Methods

- (NSNumber *)temperatureMinValue;

- (NSNumber *)temperatureMaxValue;

- (NSNumber *)temperatureStepValue;

- (NSArray *)hvacModeOptionsText;

@end


@interface ThermostatViewModel : DeviceViewModel <ThermostatViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKThermostat> device;

@end