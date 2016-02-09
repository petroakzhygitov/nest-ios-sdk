#import <Foundation/Foundation.h>
#import "DeviceDetailsViewController.h"
#import "CameraViewModel.h"

@class CameraIconView;
@protocol CameraViewModel;

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

@property(nonatomic) id <CameraViewModel> deviceViewModel;

#pragma mark Methods

@end