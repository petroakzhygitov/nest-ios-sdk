#import <NestSDK/NestSDKThermostat.h>
#import "ThermostatViewModel.h"


@implementation ThermostatViewModel
#pragma mark Private

- (NSNumber *)_temperatureValueWithTemperatureC:(CGFloat)temperatureC temperatureF:(NSUInteger)temperatureF {
    return [self _valueGrantingTemperatureScaleWithValueForC:@(temperatureC) valueForF:@(temperatureF)];
}

- (id)_valueGrantingTemperatureScaleWithValueForC:(id)valueC valueForF:(id)valueF {
    switch (self.device.temperatureScale) {
        case NestSDKThermostatTemperatureScaleUndefined:
            return nil;

        case NestSDKThermostatTemperatureScaleC:
            return valueC;

        case NestSDKThermostatTemperatureScaleF:
            return valueF;
    }

    return nil;
}

- (NSString *)_hvacModeStringWithHVACMode:(NestSDKThermostatHVACMode)hvacMode {
    switch (hvacMode) {
        case NestSDKThermostatHVACModeUndefined:
            return nil;

        case NestSDKThermostatHVACModeHeat:
            return @"Heat";

        case NestSDKThermostatHVACModeCool:
            return @"Cool";

        case NestSDKThermostatHVACModeHeatCool:
            return @"Heat-Cool";

        case NestSDKThermostatHVACModeOff:
            return @"Off";
    }

    return nil;
}

- (NestSDKThermostatHVACMode)_hvacModeWithString:(NSString *)hvacModeString {
    if ([hvacModeString isEqualToString:@"Heat"]) {
        return NestSDKThermostatHVACModeHeat;

    } else if ([hvacModeString isEqualToString:@"Cool"]) {
        return NestSDKThermostatHVACModeCool;

    } else if ([hvacModeString isEqualToString:@"Heat-Cool"]) {
        return NestSDKThermostatHVACModeHeatCool;

    } else if ([hvacModeString isEqualToString:@"Off"]) {
        return NestSDKThermostatHVACModeOff;

    } else {
        return NestSDKThermostatHVACModeUndefined;
    }
}

- (NSString *)_hvacStateStringWithHVACState:(NestSDKThermostatHVACState)hvacState {
    switch (hvacState) {
        case NestSDKThermostatHVACStateUndefined:
            return nil;

        case NestSDKThermostatHVACStateHeating:
            return @"Heating";

        case NestSDKThermostatHVACStateCooling:
            return @"Cooling";

        case NestSDKThermostatHVACStateOff:
            return @"Off";
    }

    return nil;
}

- (NSString *)_temperatureStringWithTemperatureC:(CGFloat)temperatureC temperatureF:(NSUInteger)temperatureF {
    switch (self.device.temperatureScale) {
        case NestSDKThermostatTemperatureScaleUndefined:
            return nil;

        case NestSDKThermostatTemperatureScaleC:
            return [NSString stringWithFormat:@"%.1f C", temperatureC];

        case NestSDKThermostatTemperatureScaleF:
            return [NSString stringWithFormat:@"%d F", temperatureF];
    }

    return nil;
}

#pragma mark Override

- (NSString *)localeText {
    return self.device.locale;
}

- (NSString *)lastConnectionText {
    return self.device.lastConnection;
}

- (NSNumber *)targetTemperatureHighValue {
    return [self _temperatureValueWithTemperatureC:self.device.targetTemperatureHighC
                                      temperatureF:self.device.targetTemperatureHighF];
}

- (void)setTargetTemperatureHighValue:(NSNumber *)targetTemperatureHigh {
    switch (self.device.temperatureScale) {
        case NestSDKThermostatTemperatureScaleUndefined:
            break;

        case NestSDKThermostatTemperatureScaleC:
            self.device.targetTemperatureHighC = targetTemperatureHigh.floatValue;

            break;
        case NestSDKThermostatTemperatureScaleF:
            self.device.targetTemperatureHighF = targetTemperatureHigh.unsignedIntegerValue;

            break;
    }
}

- (NSNumber *)targetTemperatureLowValue {
    return [self _temperatureValueWithTemperatureC:self.device.targetTemperatureLowC
                                      temperatureF:self.device.targetTemperatureLowF];
}

- (void)setTargetTemperatureLowValue:(NSNumber *)targetTemperatureLow {
    switch (self.device.temperatureScale) {
        case NestSDKThermostatTemperatureScaleUndefined:
            break;

        case NestSDKThermostatTemperatureScaleC:
            self.device.targetTemperatureLowC = targetTemperatureLow.floatValue;

            break;
        case NestSDKThermostatTemperatureScaleF:
            self.device.targetTemperatureLowF = targetTemperatureLow.unsignedIntegerValue;

            break;
    }
}

- (NSNumber *)targetTemperatureValue {
    return [self _temperatureValueWithTemperatureC:self.device.targetTemperatureC
                                      temperatureF:self.device.targetTemperatureF];
}

- (void)setTargetTemperatureValue:(NSNumber *)targetTemperature {
    switch (self.device.temperatureScale) {
        case NestSDKThermostatTemperatureScaleUndefined:
            break;

        case NestSDKThermostatTemperatureScaleC:
            self.device.targetTemperatureC = targetTemperature.floatValue;

            break;
        case NestSDKThermostatTemperatureScaleF:
            self.device.targetTemperatureF = targetTemperature.unsignedIntegerValue;

            break;
    }
}

- (BOOL)fanTimerActiveValue {
    return self.device.fanTimerActive;
}

- (BOOL)hasFanValue {
    return self.device.hasFan;
}

- (BOOL)hasLeafValue {
    return self.device.hasLeaf;
}

- (NSString *)temperatureScaleText {
    return [self _valueGrantingTemperatureScaleWithValueForC:@"C" valueForF:@"F"];
}

- (NSString *)isCoolingText {
    return nil;
}

- (NSString *)isHeatingText {
    return nil;
}

- (NSString *)isUsingEmergencyHeatText {
    return nil;
}

- (NSString *)fanStatusText {
    return nil;
}

- (NSString *)awayTemperatureHighText {
    return nil;
}

- (NSString *)awayTemperatureLowText {
    return nil;
}

- (NSString *)ambientTemperatureText {
    return nil;
}

- (NSString *)hasLeafText {
    return nil;
}

- (NSString *)humidityText {
    return nil;
}

- (NSString *)hvacStateText {
    return [self _hvacStateStringWithHVACState:self.device.hvacState];
}

- (NSString *)hvacModeText {
    return [self _hvacModeStringWithHVACMode:self.device.hvacMode];
}

- (void)setHvacModeText:(NSString *)hvacModeText {
    self.device.hvacMode = [self _hvacModeWithString:hvacModeText];
}

- (NSString *)energySavingText {
    return [NSString stringWithFormat:@"Energy saving: %@", self.device.hasLeaf ? @"Yes" : @"No"];
}

- (ThermostatIconViewState)iconViewState {
    switch (self.device.hvacState) {
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

- (NSNumber *)temperatureMinValue {
    return [self _temperatureValueWithTemperatureC:NestSDKThermostatTemperatureCAllowableMin
                                      temperatureF:NestSDKThermostatTemperatureFAllowableMin];
}

- (NSNumber *)temperatureMaxValue {
    return [self _temperatureValueWithTemperatureC:NestSDKThermostatTemperatureCAllowableMax
                                      temperatureF:NestSDKThermostatTemperatureFAllowableMax];
}

- (NSNumber *)temperatureStepValue {
    NSUInteger stepsC = (NestSDKThermostatTemperatureCAllowableMax - NestSDKThermostatTemperatureCAllowableMin) * 2;
    NSUInteger stepsF = NestSDKThermostatTemperatureFAllowableMax - NestSDKThermostatTemperatureFAllowableMin;

    return [self _valueGrantingTemperatureScaleWithValueForC:@(stepsC) valueForF:@(stepsF)];
}

- (NSArray *)hvacModeOptionsText {
    return @[[self _hvacModeStringWithHVACMode:NestSDKThermostatHVACModeHeat],
            [self _hvacModeStringWithHVACMode:NestSDKThermostatHVACModeCool],
            [self _hvacModeStringWithHVACMode:NestSDKThermostatHVACModeHeatCool],
            [self _hvacModeStringWithHVACMode:NestSDKThermostatHVACModeOff]];
}

@end