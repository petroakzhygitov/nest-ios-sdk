#import <Foundation/Foundation.h>
#import "DeviceDetailsViewController.h"

@class CameraIconView;
@class CameraViewModel;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface CameraDetailsViewController : DeviceDetailsViewController
#pragma mark Properties

@property IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet CameraIconView *iconView;

@property(nonatomic) CameraViewModel *deviceViewModel;

#pragma mark Methods

@end