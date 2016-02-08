#import <Foundation/Foundation.h>
#import <NestSDK/NestSDKDevice.h>

@protocol NestSDKDevice;

@protocol DeviceViewModel <NSObject, NSCopying>
#pragma mark Properties

@property(nonatomic) id <NestSDKDevice> device;

@property(nonatomic, readonly, copy) NSString *deviceIdText;
@property(nonatomic, readonly, copy) NSString *softwareVersionText;
@property(nonatomic, readonly, copy) NSString *structureIdText;
@property(nonatomic, readonly, copy) NSString *nameText;
@property(nonatomic, readonly, copy) NSString *nameLongText;
@property(nonatomic, readonly, copy) NSString *nameLongValue;
@property(nonatomic, readonly, copy) NSString *isOnlineText;
@property(nonatomic, readonly, copy) NSString *whereIdText;

#pragma mark Methods

- (id)copy;

- (NSString *)stringWithBool:(BOOL)value;

- (NSString *)stringWithDate:(NSDate *)date;

@end


@interface DeviceViewModel : NSObject <DeviceViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKDevice> device;

#pragma mark Methods

+ (id <DeviceViewModel>)viewModelWithDevice:(id <NestSDKDevice>)device;

- (instancetype)init NS_UNAVAILABLE;

- (NSString *)stringWithTitle:(NSString *)title dateValue:(NSDate *)date;

- (NSString *)stringWithTitle:(NSString *)title boolValue:(BOOL)value;

- (NSString *)stringWithTitle:(NSString *)title stringValue:(NSString *)value;

@end