#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <CoreGraphics/CGBase.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKProductResourceDataModel <NSObject>

@end


@interface NestSDKProductResourceDataModel : JSONModel
#pragma mark Properties

/**
 * Number of resource units consumed in the time period (where time period is measurement_time - measurement_reset_time). The unit of measure for this value is defined during company verification, typically joules or liters:
 *      electricity (joules)
 *      gas (joules)
 *      water (liters)
 */
@property(nonatomic) CGFloat value;

/**
 * Timestamp that identifies the start of the measurement time period, in ISO 8601 format. Generally you won't change this value, except in the rare case that connectivity or power to the device is lost.
 */
@property(nonatomic, copy) NSString <Optional> *measurement_reset_time;

/**
 * Timestamp that identifies the measurement time (the time when the resource use data was measured), in ISO 8601 format.
 */
@property(nonatomic, copy) NSString <Optional> *measurement_time;

#pragma mark Methods

@end