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
    self.hadFanRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.fanStatusText];
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
    self.fanTimerActiveRow = [self addReadWriteSwitchRowWithTitle:@"Fan timer active:" boolValue:self.deviceViewModel.fanTimerActiveValue];
}

- (void)addTemperatureScaleRow {
    self.temperatureScaleRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.temperatureScaleText];
}

- (void)addHasLeafRow {
    self.hasLeafRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.hasLeafText];
}

- (void)addAwayTemperatureHighRow {
    self.awayTemperatureHighRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.awayTemperatureHighText];
}

- (void)addAwayTemperatureLowRow {
    self.awayTemperatureLowRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.awayTemperatureLowText];
}

- (void)addAmbientTemperatureRow {
    self.ambientTemperatureRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.ambientTemperatureText];
}

- (void)addHumidityRow {
    self.humidityRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.humidityText];
}

- (void)addHVACStateRow {
    self.hvacStateRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.hvacStateText];
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

- (ThermostatViewModel *)_thermostatUpdateViewModel {
    ThermostatViewModel *thermostatUpdateViewModel = [self.deviceViewModel copy];

    thermostatUpdateViewModel.hvacModeText = self.hvacModeRow.value;
    thermostatUpdateViewModel.targetTemperatureValue = self.targetTemperatureRow.value;
    thermostatUpdateViewModel.targetTemperatureHighValue = self.targetTemperatureHighRow.value;
    thermostatUpdateViewModel.targetTemperatureLowValue = self.targetTemperatureLowRow.value;

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

//    self.deviceIdRow.value = self.deviceViewModel.deviceId;
//    self.softwareVersionRow.value = self.deviceViewModel.softwareVersion;
//    self.structureIdRow.value = self.deviceViewModel.structureId;
//    self.nameRow.value = self.deviceViewModel.name;
//    self.nameLongRow.value = self.deviceViewModel.nameLong;
//    self.isOnlineRow.value = @(self.deviceViewModel.isOnline);
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