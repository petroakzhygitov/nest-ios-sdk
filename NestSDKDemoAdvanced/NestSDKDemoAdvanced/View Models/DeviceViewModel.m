#import <NestSDK/NestSDKDevice.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import <NestSDK/NestSDKCamera.h>
#import "DeviceViewModel.h"
#import "ThermostatViewModel.h"
#import "CameraViewModel.h"
#import "SmokeCOAlarmViewModel.h"


@implementation DeviceViewModel
#pragma mark Initializer

+ (Class)_viewModelClassWithDevice:(id <NestSDKDevice>)device {
    if ([device conformsToProtocol:@protocol(NestSDKThermostat)]) {
        return [ThermostatViewModel class];

    } else if ([device conformsToProtocol:@protocol(NestSDKSmokeCOAlarm)]) {
        return [SmokeCOAlarmViewModel class];

    } else if ([device conformsToProtocol:@protocol(NestSDKCamera)]) {
        return [CameraViewModel class];
    }

    return nil;
}

#pragma mark Private

+ (id <DeviceViewModel>)viewModelWithDevice:(id <NestSDKDevice>)device {
    Class viewModelClass = [self _viewModelClassWithDevice:device];

    id <DeviceViewModel> deviceViewModel = (id <DeviceViewModel>) [[viewModelClass alloc] init];
    deviceViewModel.device = device;

    return deviceViewModel;
}

#pragma mark Public

- (NSString *)textWithBoolValue:(BOOL)value {
    return value ? @"Yes" : @"No";
}

#pragma mark Override

- (NSString *)deviceIdText {
    return self.device.deviceId;
}

- (NSString *)softwareVersionText {
    return self.device.softwareVersion;
}

- (NSString *)structureIdText {
    return self.device.structureId;
}

- (NSString *)nameText {
    return self.device.name;
}

- (NSString *)nameLongText {
    return self.device.nameLong;
}

- (NSString *)isOnlineText {
    return [self textWithBoolValue:self.device.isOnline];
}

- (NSString *)whereIdText {
    return self.device.whereId;
}

@end