#import <NestSDK/NestSDKThermostat.h>
#import "ThermostatViewModel.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation ThermostatViewModel {
#pragma mark Instance variables
}

#pragma mark Initializer

+ (instancetype)viewModelWithThermostat:(id <NestSDKThermostat>)thermostat {
    return [[ThermostatViewModel alloc] initWithThermostat:thermostat];
}

- (instancetype)initWithThermostat:(id <NestSDKThermostat>)thermostat {
    self = [super init];
    if (self) {

    }

    return self;
}

#pragma mark Private

- (NSString *)_energySavingStringWithThermostat:(id <NestSDKThermostat>)thermostat {
    return [NSString stringWithFormat:@"Energy saving: %@", thermostat.hasLeaf ? @"Yes" : @"No"];
}

- (CGFloat)_targetTemperatureWithThermostat:(id <NestSDKThermostat>)thermostat {
    switch (thermostat.temperatureScale) {
        case NestSDKThermostatTemperatureScaleC:
            return thermostat.targetTemperatureC;

        case NestSDKThermostatTemperatureScaleF:
            return thermostat.targetTemperatureF;

        case NestSDKThermostatTemperatureScaleUndefined:
            return 0;
    }

    return 0;
}

- (ThermostatIconViewState)_thermostatIconViewStateWithThermostat:(id <NestSDKThermostat>)thermostat {
    switch (thermostat.hvacState) {
        case NestSDKThermostatHVACStateUndefined:
        case NestSDKThermostatHVACStateOff:
            return ThermostatIconViewStateOff;

        case NestSDKThermostatHVACStateHeating:
            return ThermostatIconViewStateHeating;

        case NestSDKThermostatHVACStateCooling:
            return ThermostatIconViewStateCooling;
    }

    return ThermostatIconViewStateOff;
}

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end