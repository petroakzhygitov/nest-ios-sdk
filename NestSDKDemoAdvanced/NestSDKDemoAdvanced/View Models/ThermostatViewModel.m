#import <NestSDK/NestSDKThermostat.h>
#import "ThermostatViewModel.h"


@implementation ThermostatViewModel

@synthesize device;

#pragma mark Private

- (NSString *)_stringWithTitle:(NSString *)title temperatureValue:(NSNumber *)value {
    NSString *temperatureString = [NSString stringWithFormat:@"%@ %@", value.stringValue, [self temperatureScaleText]];
    [self stringWithTitle:value.stringValue stringValue:temperatureString];

    return [self stringWithTitle:title stringValue:temperatureString];
}

- (NSString *)_temperatureScaleString {
    return [self _valueGrantingTemperatureScaleWithValueForC:@"C" valueForF:@"F"];
}

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

- (NSString *)_hvacStateString {
    return [self _hvacStateStringWithHVACState:self.device.hvacState];
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


#pragma mark Override

- (NSString *)localeText {
    return [self stringWithTitle:@"Locale:" stringValue:self.device.locale];
}

- (NSString *)lastConnectionText {
    return [self stringWithTitle:@"Last connection:" dateValue:self.device.lastConnection];
}

- (NSString *)targetTemperatureHighTitle {
    return @"Target temperature high:";
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

- (NSString *)targetTemperatureLowTitle {
    return @"Target temperature low:";
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

- (NSString *)targetTemperatureTitle {
    return @"Target temperature:";
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

- (NSString *)fanTimerActiveTitle {
    return @"Fan timer active:";
}

- (NSNumber *)fanTimerActiveValue {
    return @(self.device.fanTimerActive);
}

- (void)setFanTimerActiveValue:(NSNumber *)value {
    self.device.fanTimerActive = value.boolValue;
}

- (NSString *)fanTimerTimeoutText {
    return [self stringWithTitle:@"Fan timer timeout:" dateValue:self.device.fanTimerTimeout];
}

- (NSString *)hasFanText {
    return [self stringWithTitle:@"Fan is on:" boolValue:self.device.hasFan];
}

- (NSNumber *)hasFanValue {
    return @(self.device.hasFan);
}

- (NSString *)hasLeafText {
    return [self stringWithTitle:@"Energy saving mode:" boolValue:self.device.hasLeaf];
}

- (NSNumber *)hasLeafValue {
    return @(self.device.hasLeaf);
}

- (NSString *)temperatureScaleText {
    return [self stringWithTitle:@"Temperature scale:" stringValue:[self _temperatureScaleString]];
}

- (NSString *)isCoolingText {
    return [self stringWithTitle:@"Is cooling:" boolValue:self.device.canCool];
}

- (NSString *)isHeatingText {
    return [self stringWithTitle:@"Is heating:" boolValue:self.device.canHeat];
}

- (NSString *)isUsingEmergencyHeatText {
    return [self stringWithTitle:@"Is using emergency heat:" boolValue:self.device.isUsingEmergencyHeat];
}

- (NSString *)awayTemperatureHighText {
    NSNumber *temperatureValue = [self _temperatureValueWithTemperatureC:self.device.awayTemperatureHighC
                                                            temperatureF:self.device.awayTemperatureHighF];

    return [self _stringWithTitle:@"Away temperature high:" temperatureValue:temperatureValue];
}

- (NSString *)awayTemperatureLowText {
    NSNumber *temperatureValue = [self _temperatureValueWithTemperatureC:self.device.awayTemperatureLowC
                                                            temperatureF:self.device.awayTemperatureLowF];

    return [self _stringWithTitle:@"Away temperature low:" temperatureValue:temperatureValue];
}

- (NSString *)ambientTemperatureText {
    NSNumber *temperatureValue = [self _temperatureValueWithTemperatureC:self.device.ambientTemperatureC
                                                            temperatureF:self.device.ambientTemperatureF];

    return [self _stringWithTitle:@"Ambient temperature:" temperatureValue:temperatureValue];
}

- (NSString *)humidityText {
    return [self stringWithTitle:@"Humidity:" stringValue:@(self.device.humidity).stringValue];
}

- (NSString *)hvacStateText {
    return [self stringWithTitle:@"HVAC State:" stringValue:[self _hvacStateString]];
}

- (NSString *)hvacModeText {
    return [self _hvacModeStringWithHVACMode:self.device.hvacMode];
}

- (NSString *)hvacModeTitle {
    return @"HVAC Mode:";
}

- (void)setHvacModeText:(NSString *)hvacModeText {
    self.device.hvacMode = [self _hvacModeWithString:hvacModeText];
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