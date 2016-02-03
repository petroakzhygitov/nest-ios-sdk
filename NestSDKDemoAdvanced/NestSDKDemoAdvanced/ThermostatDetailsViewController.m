#import <XLForm/XLForm.h>
#import <NestSDK/NestSDKThermostat.h>
#import "ThermostatDetailsViewController.h"

@interface ThermostatDetailsViewController ()

@property(nonatomic, strong) XLFormSectionDescriptor *section;

@end


@implementation ThermostatDetailsViewController
#pragma mark Override

- (void)initForm {
    [super initForm];

    [self addLocaleRow];
    [self addLasConnectionRow];

    [self addCanCoolRow];
    [self addCanHeatRow];
    [self addIsUsingEmergencyHeatRow];
    [self hasFan];

//    @property(nonatomic) BOOL fanTimerActive;
//    @property(nonatomic) NSDate *fanTimerTimeout;
//    @property(nonatomic, readonly) BOOL hasLeaf;
//    @property(nonatomic, readonly) NestSDKThermostatTemperatureScale temperatureScale;
//    @property(nonatomic) NSUInteger targetTemperatureF;
//    @property(nonatomic) CGFloat targetTemperatureC;
//    @property(nonatomic) NSUInteger targetTemperatureHighF;
//    @property(nonatomic) CGFloat targetTemperatureHighC;
//    @property(nonatomic) NSUInteger targetTemperatureLowF;
//    @property(nonatomic) CGFloat targetTemperatureLowC;
//    @property(nonatomic, readonly) NSUInteger awayTemperatureHighF;
//    @property(nonatomic, readonly) CGFloat awayTemperatureHighC;
//    @property(nonatomic, readonly) NSUInteger awayTemperatureLowF;
//    @property(nonatomic, readonly) CGFloat awayTemperatureLowC;
//    @property(nonatomic) NestSDKThermostatHVACMode hvacMode;
//    @property(nonatomic, readonly) CGFloat ambientTemperatureC;
//    @property(nonatomic, readonly) NSUInteger ambientTemperatureF;
//    @property(nonatomic, readonly) NSUInteger humidity;
//    @property(nonatomic, readonly) NestSDKThermostatHVACState hvacState;
}

- (void)addCanCoolRow {
    [self addDisabledTextRowWithTitle:@"Can cool:" boolValue:self.device.canCool];
}

- (void)addCanHeatRow {
    [self addDisabledTextRowWithTitle:@"Can heat:" boolValue:self.device.canHeat];
}

- (void)addIsUsingEmergencyHeatRow {
    [self addDisabledTextRowWithTitle:@"Is using emergency heat:" boolValue:self.device.isUsingEmergencyHeat];
}

- (void)hasFan {
    [self addDisabledTextRowWithTitle:@"Has fan:" boolValue:self.device.hasFan];
}

- (void)addLocaleRow {
    [self addDisabledTextRowWithTitle:@"Locale:" text:self.device.locale];
}

- (void)addLasConnectionRow {
    [self addDisabledDateTimeRowWithTitle:@"Last connection:" date:self.device.lastConnection];
}

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end