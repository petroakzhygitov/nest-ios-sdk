#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ThermostatViewCell;
@class CameraViewCell;
@class SmokeCOAlarmViewCell;

@interface DevicesViewControllerHelper : NSObject
#pragma mark Methods

+ (void)populateCell:(UITableViewCell *)cell withDevice:(id <NestSDKDevice>)device;

+ (void)passDevice:(id <NestSDKDevice>)device toViewController:(UIViewController *)controller;

+ (NSUInteger)devicesForStructure:(id <NestSDKStructure>)structure;

+ (NSString *)deviceIdWithIndex:(NSUInteger)deviceIndex forStructure:(id <NestSDKStructure>)structure;

+ (NSString *)cellIdentifierWithStructure:(id <NestSDKStructure>)structure deviceIndex:(NSUInteger)deviceIndex;

+ (NSString *)segueIdentifierWithStructure:(id <NestSDKStructure>)structure deviceIndex:(NSUInteger)deviceIndex;

@end