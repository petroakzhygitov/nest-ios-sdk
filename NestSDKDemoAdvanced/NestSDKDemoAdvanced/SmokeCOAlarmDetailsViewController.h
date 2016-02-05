#import <Foundation/Foundation.h>
#import "DeviceDetailsViewController.h"

@class SmokeCOAlarmIconView;
@class SmokeCOAlarmViewModel;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface SmokeCOAlarmDetailsViewController : DeviceDetailsViewController
#pragma mark Properties

@property IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet SmokeCOAlarmIconView *iconView;

@property(nonatomic) SmokeCOAlarmViewModel *deviceViewModel;

@property(nonatomic, strong) XLFormRowDescriptor *localeRow;
@property(nonatomic, strong) XLFormRowDescriptor *lastConnectionRow;
@property(nonatomic, strong) XLFormRowDescriptor *batteryHealthRow;
#pragma mark Methods

@end