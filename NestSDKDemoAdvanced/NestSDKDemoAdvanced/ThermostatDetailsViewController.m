#import <XLForm/XLForm.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKDataManager.h>
#import "ThermostatDetailsViewController.h"
#import "TemperatureSliderViewCell.h"


static NSString *const kTemperatureSliderViewCell = @"TemperatureSliderViewCell";


@implementation ThermostatDetailsViewController
#pragma mark Private

- (void)_addLocaleRow {
    self.localeRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.localeText];
}

- (void)_addLasConnectionRow {
    self.lastConnectionRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.lastConnectionText];
}

- (void)_addCanCoolRow {
    self.canCoolRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.isCoolingText];
}

- (void)_addCanHeatRow {
    self.canHeatRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.isHeatingText];
}

- (void)_addIsUsingEmergencyHeatRow {
    self.isUsingEmergencyHeatRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.isUsingEmergencyHeatText];
}

- (void)_addHasFanRow {
    self.hasFanRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.hasFanText];
}

- (void)_addHasLeafRow {
    self.hasLeafRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.hasLeafText];
}

- (void)_addTemperatureScaleRow {
    self.temperatureScaleRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.temperatureScaleText];
}

- (void)_addAwayTemperatureHighRow {
    self.awayTemperatureHighRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.awayTemperatureHighText];
}

- (void)_addAwayTemperatureLowRow {
    self.awayTemperatureLowRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.awayTemperatureLowText];
}

- (void)_addAmbientTemperatureRow {
    self.ambientTemperatureRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.ambientTemperatureText];
}

- (void)_addFanTimerTimeoutRow {
    self.fanTimerTimeoutRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.fanTimerTimeoutText];
}

- (void)_addHumidityRow {
    self.humidityRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.humidityText];
}

- (void)_addHVACStateRow {
    self.hvacStateRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.hvacStateText];
}

- (void)_addHVACModeRow {
    self.hvacModeRow = [self _addReadWriteInlinePickerRowWithTitle:self.deviceViewModel.hvacModeTitle
                                                           options:self.deviceViewModel.hvacModeOptionsText
                                                             value:self.deviceViewModel.hvacModeText];
}

- (void)_addTargetTemperatureHighRow {
    self.targetTemperatureHighRow = [self _addReadWriteTemperatureSliderRowWithTitle:self.deviceViewModel.targetTemperatureHighTitle
                                                                               value:self.deviceViewModel.targetTemperatureHighValue];
}

- (void)_addTargetTemperatureLowRow {
    self.targetTemperatureLowRow = [self _addReadWriteTemperatureSliderRowWithTitle:self.deviceViewModel.targetTemperatureLowTitle
                                                                              value:self.deviceViewModel.targetTemperatureLowValue];
}

- (void)_addTargetTemperatureRow {
    self.targetTemperatureRow = [self _addReadWriteTemperatureSliderRowWithTitle:self.deviceViewModel.targetTemperatureTitle
                                                                           value:self.deviceViewModel.targetTemperatureValue];
}

- (void)_addFanTimerActive {
    self.fanTimerActiveRow = [self addReadWriteSwitchRowWithTitle:self.deviceViewModel.fanTimerActiveTitle
                                                        boolValue:self.deviceViewModel.fanTimerActiveValue];
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

- (ThermostatViewModel *)_thermostatUpdateViewModel {
    ThermostatViewModel *thermostatUpdateViewModel = [self.deviceViewModel copy];

    thermostatUpdateViewModel.hvacModeText = self.hvacModeRow.value;
    thermostatUpdateViewModel.targetTemperatureValue = self.targetTemperatureRow.value;
    thermostatUpdateViewModel.targetTemperatureHighValue = self.targetTemperatureHighRow.value;
    thermostatUpdateViewModel.targetTemperatureLowValue = self.targetTemperatureLowRow.value;
    thermostatUpdateViewModel.fanTimerActiveValue = self.fanTimerActiveRow.value;

    return thermostatUpdateViewModel;
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

- (void)updateDeviceData {
    // Updating device data using temporary viewModel, since if update fails we'll revert data to original from deviceViewModel
    ThermostatViewModel *thermostatUpdateViewModel = [self _thermostatUpdateViewModel];

    [self.dataManager setThermostat:thermostatUpdateViewModel.device
                              block:(NestSDKThermostatUpdateHandler) self.deviceUpdateHandlerBlock];
}

- (void)updateTableViewHeader {
    [super updateTableViewHeader];

    self.nameLabel.text = self.deviceViewModel.nameLongValue;

    self.iconView.state = self.deviceViewModel.iconViewState;
    self.iconView.targetTemperatureValue = self.deviceViewModel.targetTemperatureValue;
    self.iconView.hasFan = self.deviceViewModel.hasFanValue;
    self.iconView.hasLeaf = self.deviceViewModel.hasLeafValue;
}

- (void)updateTableViewData {
    self.updatingTableViewData = YES;

    self.localeRow.value = self.deviceViewModel.localeText;
    self.lastConnectionRow.value = self.deviceViewModel.lastConnectionText;

    self.hasFanRow.value = self.deviceViewModel.hasFanText;
    self.hasLeafRow.value = self.deviceViewModel.hasLeafText;

    self.temperatureScaleRow.value = self.deviceViewModel.temperatureScaleText;

    self.canCoolRow.value = self.deviceViewModel.isCoolingText;
    self.canHeatRow.value = self.deviceViewModel.isHeatingText;
    self.isUsingEmergencyHeatRow.value = self.deviceViewModel.isUsingEmergencyHeatText;

    self.awayTemperatureHighRow.value = self.deviceViewModel.awayTemperatureHighText;
    self.awayTemperatureLowRow.value = self.deviceViewModel.awayTemperatureLowText;

    self.ambientTemperatureRow.value = self.deviceViewModel.ambientTemperatureText;
    self.humidityRow.value = self.deviceViewModel.humidityText;
    self.hvacStateRow.value = self.deviceViewModel.hvacStateText;

    self.hvacModeRow.value = self.deviceViewModel.hvacModeText;

    self.targetTemperatureRow.value = self.deviceViewModel.targetTemperatureValue;
    self.targetTemperatureHighRow.value = self.deviceViewModel.targetTemperatureHighValue;
    self.targetTemperatureLowRow.value = self.deviceViewModel.targetTemperatureLowValue;

    self.fanTimerActiveRow.value = self.deviceViewModel.fanTimerActiveValue;

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
    [self _addHasLeafRow];

    [self _addTemperatureScaleRow];

    [self _addAwayTemperatureHighRow];
    [self _addAwayTemperatureLowRow];

    [self _addAmbientTemperatureRow];
    [self _addFanTimerTimeoutRow];
    [self _addHumidityRow];

    [self _addHVACStateRow];

    [self _addHVACModeRow];

    [self _addTargetTemperatureRow];
    [self _addTargetTemperatureHighRow];
    [self _addTargetTemperatureLowRow];

    [self _addFanTimerActive];
}

@end