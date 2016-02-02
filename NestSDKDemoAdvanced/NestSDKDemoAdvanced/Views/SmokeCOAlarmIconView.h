#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DeviceIconView.h"

#pragma mark typedef

typedef NS_ENUM(NSUInteger, SmokeCOAlarmIconViewColor) {
    SmokeCOAlarmIconViewColorGreen,
    SmokeCOAlarmIconViewColorYellow,
    SmokeCOAlarmIconViewColorRed,
    SmokeCOAlarmIconViewColorGray
};


@interface SmokeCOAlarmIconView : DeviceIconView
#pragma mark Properties

@property(nonatomic) SmokeCOAlarmIconViewColor color;

@end