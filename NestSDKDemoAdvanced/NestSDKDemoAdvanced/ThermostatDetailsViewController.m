#import <XLForm/XLForm.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKDataManager.h>
#import "ThermostatDetailsViewController.h"
#import "TemperatureSliderViewCell.h"


static NSString *const kTemperatureSliderViewCell = @"TemperatureSliderViewCell";


@implementation ThermostatDetailsViewController
#pragma mark Private

- (void)_addLocaleRow {
    self.localeRow = [self addReadOnlyTextRowWithTitle:@"Locale:" text:self.deviceViewModel.localeText];
}

- (void)_addLasConnectionRow {
    self.lastConnectionRow = [self addReadOnlyTextRowWithTitle:@"Last connection:" text:self.deviceViewModel.lastConnectionText];
}

- (void)_addCanCoolRow {
    self.canCoolRow = [self addReadOnlyTextRowWithTitle:@"Is cooling:" text:self.deviceViewModel.isCoolingText];
}

- (void)_addCanHeatRow {
    self.canHeatRow = [self addReadOnlyTextRowWithTitle:@"Is heating:" text:self.deviceViewModel.isHeatingText];
}

- (void)_addIsUsingEmergencyHeatRow {
    self.isUsingEmergencyHeatRow = [self addReadOnlyTextRowWithTitle:@"Is using emergency heat:"
                                                                text:self.deviceViewModel.isUsingEmergencyHeatText];
}

- (void)_addHasFanRow {
    self.hadFanRow = [self addReadOnlyTextRowWithTitle:@"Fan status:" text:self.deviceViewModel.fanStatusText];
}

- (void)addTargetTemperatureHighRow {
    self.targetTemperatureHighRow = [self _addReadWriteTemperatureSliderRowWithTitle:@"Target temperature high:"
                                                                               value:self.deviceViewModel.targetTemperatureHighValue];
}

- (void)addTargetTemperatureLowRow {
    self.targetTemperatureLowRow = [self _addReadWriteTemperatureSliderRowWithTitle:@"Target temperature low:"
                                                                              value:self.deviceViewModel.targetTemperatureLowValue];
}

- (void)addTargetTemperatureRow {
    self.targetTemperatureRow = [self _addReadWriteTemperatureSliderRowWithTitle:@"Target temperature:"
                                                                           value:self.deviceViewModel.targetTemperatureValue];
}

- (void)addFanTimerActive {
    self.fanTimerActiveRow = [self addReadWriteTextRowWithTitle:@"Fan timer active:" boolValue:self.deviceViewModel.fanTimerActiveValue];
}

- (void)addTemperatureScaleRow {
    self.temperatureScaleRow = [self addReadOnlyTextRowWithTitle:@"Temperature scale:" text:self.deviceViewModel.temperatureScaleText];
}

- (void)addHasLeafRow {
    self.hasLeafRow = [self addReadOnlyTextRowWithTitle:@"Has leaf:" text:self.deviceViewModel.hasLeafText];
}

- (void)addAwayTemperatureHighRow {
    self.awayTemperatureHighRow = [self addReadOnlyTextRowWithTitle:@"Away temperature high:"
                                                               text:self.deviceViewModel.awayTemperatureHighText];
}

- (void)addAwayTemperatureLowRow {
    self.awayTemperatureLowRow = [self addReadOnlyTextRowWithTitle:@"Away temperature low:"
                                                              text:self.deviceViewModel.awayTemperatureLowText];
}

- (void)addAmbientTemperatureRow {
    self.ambientTemperatureRow = [self addReadOnlyTextRowWithTitle:@"Ambient temperature:"
                                                              text:self.deviceViewModel.ambientTemperatureText];
}

- (void)addHumidityRow {
    self.humidityRow = [self addReadOnlyTextRowWithTitle:@"Humidity:" text:self.deviceViewModel.humidityText];
}

- (void)addHVACStateRow {
    self.hvacStateRow = [self addReadOnlyTextRowWithTitle:@"HVAC state:" text:self.deviceViewModel.hvacStateText];
}

- (void)addHVACModeRow {
    NSArray *options = self.deviceViewModel.hvacModeOptionsText;
    NSString *value = self.deviceViewModel.hvacModeText;

    self.hvacModeRow = [self _addReadWriteInlinePickerRowWithTitle:@"HVAC Mode:" options:options value:value];
}

- (XLFormRowDescriptor *)_addReadWriteInlinePickerRowWithTitle:(NSString *)title options:(NSArray *)options value:(NSString *)value {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:title];
    row.selectorOptions = options;
    row.value = value;

    [self addReadWriteRow:row];

    return row;
}

- (XLFormRowDescriptor *)_addReadWriteTemperatureSliderRowWithTitle:(NSString *)title value:(NSNumber *)value {
    XLFormRowDescriptor *row = [self _temperatureSliderRowWithTitle:title value:value];
    [self addReadWriteRow:row];

    return row;
}

- (XLFormRowDescriptor *)_temperatureSliderRowWithTitle:(NSString *)title value:(NSNumber *)value {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:kTemperatureSliderViewCell title:title];
    row.value = value;
    row.cellConfigAtConfigure[@"slider.maximumValue"] = self.deviceViewModel.temperatureMaxValue;
    row.cellConfigAtConfigure[@"slider.minimumValue"] = self.deviceViewModel.temperatureMinValue;
    row.cellConfigAtConfigure[@"steps"] = self.deviceViewModel.temperatureStepValue;

    return row;
}

#pragma mark Override

- (void)addTitle {
    self.title = @"Thermostat";
}

- (void)addForm {
    [super addForm];

    [[XLFormViewController cellClassesForRowDescriptorTypes] setObject:[TemperatureSliderViewCell class] forKey:kTemperatureSliderViewCell];
}

- (void)addDeviceObservers {
    [self.dataManager observeThermostatWithId:self.deviceViewModel.device.deviceId
                                        block:(NestSDKThermostatUpdateHandler) self.deviceUpdateHandlerBlock];
}

- (void)updateDeviceViewModelData {
//    [self _setDeviceHVACMode:[self _hvacModeWithString:self.hvacModeRow.value]];
    self.deviceViewModel.targetTemperatureValue = self.targetTemperatureRow.value;
    self.deviceViewModel.targetTemperatureHighValue = self.targetTemperatureHighRow.value;
    self.deviceViewModel.targetTemperatureLowValue = self.targetTemperatureLowRow.value;
}

- (void)setDeviceViewModelData {
    [self.dataManager setThermostat:self.deviceViewModel.device
                              block:(NestSDKThermostatUpdateHandler) self.deviceUpdateHandlerBlock];
}

- (void)updateTableViewHeader {
    [super updateTableViewHeader];

    self.nameLabel.text = self.deviceViewModel.nameLongText;

    self.iconView.state = self.deviceViewModel.iconViewState;
    self.iconView.targetTemperatureValue = self.deviceViewModel.targetTemperatureValue;
}

- (void)updateTableViewData {
    self.updatingTableViewData = YES;

//    self.deviceIdRow.value = self.deviceViewModel.deviceId;
//    self.softwareVersionRow.value = self.deviceViewModel.softwareVersion;
//    self.structureIdRow.value = self.deviceViewModel.structureId;
//    self.nameIdRow.value = self.deviceViewModel.name;
//    self.nameLongIdRow.value = self.deviceViewModel.nameLong;
//    self.isOnlineIdRow.value = @(self.deviceViewModel.isOnline);
//    self.whereIdRow.value = self.deviceViewModel.whereId;

    self.targetTemperatureRow.value = self.deviceViewModel.targetTemperatureValue;
    self.targetTemperatureHighRow.value = self.deviceViewModel.targetTemperatureHighValue;
    self.targetTemperatureLowRow.value = self.deviceViewModel.targetTemperatureLowValue;

    [super updateTableViewData];
}

- (void)addRows {
    [super addRows];

    [self _addLocaleRow];
    [self _addLasConnectionRow];

    [self _addCanCoolRow];
    [self _addCanHeatRow];
    [self _addIsUsingEmergencyHeatRow];
    [self _addHasFanRow];

    [self addFanTimerActive];
//    @property(nonatomic) NSDate *fanTimerTimeout;

    [self addHasLeafRow];

    [self addTemperatureScaleRow];

    [self addTargetTemperatureRow];
    [self addTargetTemperatureHighRow];
    [self addTargetTemperatureLowRow];

    [self addAwayTemperatureHighRow];
    [self addAwayTemperatureLowRow];

    [self addAmbientTemperatureRow];
    [self addHumidityRow];

    [self addHVACStateRow];
    [self addHVACModeRow];
}

@end