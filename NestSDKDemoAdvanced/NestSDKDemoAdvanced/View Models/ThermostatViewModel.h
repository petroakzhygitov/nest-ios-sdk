#import <Foundation/Foundation.h>
#import "ThermostatIconView.h"

@interface ThermostatViewModel : NSObject
#pragma mark Methods

@property(nonatomic, copy) NSString *nameLongText;

@property(nonatomic, copy) NSString *energySavingText;

@property(nonatomic) enum ThermostatIconViewState iconViewState;

@property(nonatomic) CGFloat iconViewTargetTemperature;

- (instancetype)initWithThermostat:(id <NestSDKThermostat>)thermostat;

+ (instancetype)viewModelWithThermostat:(id <NestSDKThermostat>)device;
@end