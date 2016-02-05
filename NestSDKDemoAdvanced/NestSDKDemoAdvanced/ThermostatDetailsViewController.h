#import "DeviceDetailsViewController.h"
#import <Foundation/Foundation.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKDevice.h>
#import "ThermostatViewModel.h"

@protocol NestSDKThermostat;
@protocol ThermostatViewModel;
@class ThermostatIconView;


@interface ThermostatDetailsViewController : DeviceDetailsViewController
#pragma mark Properties

@property IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet ThermostatIconView *iconView;

@property(nonatomic) id <ThermostatViewModel> deviceViewModel;

@property(nonatomic) XLFormRowDescriptor *localeRow;
@property(nonatomic) XLFormRowDescriptor *lastConnectionRow;
@property(nonatomic) XLFormRowDescriptor *canCoolRow;
@property(nonatomic) XLFormRowDescriptor *canHeatRow;
@property(nonatomic) XLFormRowDescriptor *isUsingEmergencyHeatRow;
@property(nonatomic) XLFormRowDescriptor *hadFanRow;
@property(nonatomic) XLFormRowDescriptor *hasLeafRow;
@property(nonatomic) XLFormRowDescriptor *temperatureScaleRow;

@property(nonatomic) XLFormRowDescriptor *targetTemperatureRow;
@property(nonatomic) XLFormRowDescriptor *targetTemperatureLowRow;
@property(nonatomic) XLFormRowDescriptor *targetTemperatureHighRow;

@property(nonatomic) XLFormRowDescriptor *awayTemperatureHighRow;
@property(nonatomic) XLFormRowDescriptor *awayTemperatureLowRow;

@property(nonatomic) XLFormRowDescriptor *ambientTemperatureRow;
@property(nonatomic) XLFormRowDescriptor *humidityRow;

@property(nonatomic) XLFormRowDescriptor *hvacStateRow;
@property(nonatomic) XLFormRowDescriptor *hvacModeRow;

@property(nonatomic) XLFormRowDescriptor *fanTimerActiveRow;

@end