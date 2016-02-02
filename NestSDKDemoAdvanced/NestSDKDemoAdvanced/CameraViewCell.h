#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CameraIconView;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface CameraViewCell : UITableViewCell
#pragma mark Properties

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet CameraIconView *iconView;
#pragma mark Methods

@end