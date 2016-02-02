#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SmokeCOAlarmIconView;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface SmokeCOAlarmViewCell : UITableViewCell
#pragma mark Properties

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryStatusLabel;

@property (weak, nonatomic) IBOutlet SmokeCOAlarmIconView *iconView;

#pragma mark Methods

@end