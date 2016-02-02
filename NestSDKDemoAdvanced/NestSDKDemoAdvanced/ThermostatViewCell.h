#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ThermostatIconView;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface ThermostatViewCell : UITableViewCell
#pragma mark Properties

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *energySavingLabel;

@property (weak, nonatomic) IBOutlet ThermostatIconView *iconView;

#pragma mark Methods

@end