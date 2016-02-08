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
@property(nonatomic, readonly, copy) NSString *energySavingText;

@property(nonatomic, readonly, copy) NSString *localeText;
@property(nonatomic, readonly, copy) id lastConnectionText;

@property(nonatomic) NSNumber *targetTemperatureHighValue;
@property(nonatomic) NSNumber *targetTemperatureLowValue;
@property(nonatomic) NSNumber *targetTemperatureValue;

@property(nonatomic) BOOL fanTimerActiveValue;

@property(nonatomic) BOOL hasFanValue;
@property(nonatomic) BOOL hasLeafValue;

@property(nonatomic, readonly, copy) NSString *temperatureScaleText;

@property(nonatomic, readonly, copy) NSString *isCoolingText;
@property(nonatomic, readonly, copy) NSString *isHeatingText;
@property(nonatomic, readonly, copy) NSString *isUsingEmergencyHeatText;
@property(nonatomic, readonly, copy) NSString *fanStatusText;

@property(nonatomic, readonly, copy) NSString *awayTemperatureHighText;
@property(nonatomic, readonly, copy) NSString *awayTemperatureLowText;

@property(nonatomic, readonly, copy) NSString *ambientTemperatureText;

@property(nonatomic, readonly, copy) NSString *hasLeafText;

@property(nonatomic, readonly, copy) NSString *humidityText;

@property(nonatomic, readonly, copy) NSString *hvacStateText;

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