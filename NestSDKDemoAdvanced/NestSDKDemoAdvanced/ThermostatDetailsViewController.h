#import "DeviceDetailsViewController.h"
#import <Foundation/Foundation.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKDevice.h>

@protocol NestSDKThermostat;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface ThermostatDetailsViewController : DeviceDetailsViewController
#pragma mark Properties

@property(nonatomic) id <NestSDKThermostat> device;

@property IBOutlet UITableView *tableView;

#pragma mark Methods

@end