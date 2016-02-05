#import <Foundation/Foundation.h>
#import <NestSDK/NestSDKDevice.h>

@protocol NestSDKDevice;

@protocol DeviceViewModel <NSObject>
#pragma mark Properties

@property(nonatomic) id <NestSDKDevice> device;

@property(nonatomic, readonly, copy) NSString *deviceIdText;
@property(nonatomic, readonly, copy) NSString *softwareVersionText;
@property(nonatomic, readonly, copy) NSString *structureIdText;
@property(nonatomic, readonly, copy) NSString *nameText;
@property(nonatomic, readonly, copy) NSString *nameLongText;
@property(nonatomic, readonly, copy) NSString *isOnlineText;
@property(nonatomic, readonly, copy) NSString *whereIdText;

@end


@interface DeviceViewModel : NSObject <DeviceViewModel>
#pragma mark Properties

@property(nonatomic) id <NestSDKDevice> device;

#pragma mark Methods

+ (id <DeviceViewModel>)viewModelWithDevice:(id <NestSDKDevice>)device;

- (instancetype)init NS_UNAVAILABLE;

@end