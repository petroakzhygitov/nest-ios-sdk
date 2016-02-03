#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XLForm/XLFormViewController.h>
#import <NestSDK/NestSDKDevice.h>

@protocol NestSDKDevice;


@interface DeviceDetailsViewController : XLFormViewController
#pragma mark Properties

@property(nonatomic) id <NestSDKDevice> device;

#pragma mark Methods

- (void)initForm;

- (void)addDisabledTextRowWithTitle:(NSString *)title text:(NSString *)text;

- (void)addDisabledTextRowWithTitle:(NSString *)title boolValue:(BOOL)value;

- (void)addDisabledDateTimeRowWithTitle:(NSString *)title date:(NSDate *)date;

@end