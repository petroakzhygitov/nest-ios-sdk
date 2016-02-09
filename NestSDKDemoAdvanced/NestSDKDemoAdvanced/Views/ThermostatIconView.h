#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DeviceIconView.h"

#pragma mark typedef

typedef NS_ENUM(NSUInteger, ThermostatIconViewState) {
    ThermostatIconViewStateOff,
    ThermostatIconViewStateHeating,
    ThermostatIconViewStateCooling
};

@interface ThermostatIconView : DeviceIconView
#pragma mark Properties

@property(nonatomic) ThermostatIconViewState state;
@property(nonatomic) NSNumber *targetTemperatureValue;

@property(nonatomic) NSNumber *hasLeaf;
@property(nonatomic) NSNumber *hasFan;

@end