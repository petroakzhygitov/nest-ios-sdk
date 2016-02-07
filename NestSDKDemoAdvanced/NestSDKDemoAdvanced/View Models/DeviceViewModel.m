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

#pragma mark Override

- (id)copyWithZone:(NSZone *)zone {
    id <DeviceViewModel> copy = (id <DeviceViewModel>) [[[self class] alloc] init];

    if (copy) {
        copy.device = [self.device copy];
    }

    return copy;
}

- (NSString *)deviceIdText {
    return [self stringWithTitle:@"Device ID:" stringValue:self.device.deviceId];
}

- (NSString *)softwareVersionText {
    return [self stringWithTitle:@"Software version:" stringValue:self.device.softwareVersion];
}

- (NSString *)structureIdText {
    return [self stringWithTitle:@"Structure ID:" stringValue:self.device.structureId];
}

- (NSString *)nameText {
    return [self stringWithTitle:@"Name:" stringValue:self.device.name];
}

- (NSString *)nameLongText {
    return [self stringWithTitle:@"Long name:" stringValue:self.device.nameLong];
}

- (NSString *)isOnlineText {
    return [self stringWithTitle:@"Online:" boolValue:self.device.isOnline];
}

- (NSString *)whereIdText {
    return [self stringWithTitle:@"Where ID:" stringValue:self.device.whereId];
}

#pragma mark Public

- (id)copy {
    return [self copyWithZone:nil];
}

- (NSString *)stringWithTitle:(NSString *)title dateValue:(NSDate *)date {
    return [self stringWithTitle:title stringValue:[self stringWithDate:date]];
}

- (NSString *)stringWithTitle:(NSString *)title boolValue:(BOOL)value {
    return [self stringWithTitle:title stringValue:[self stringWithBool:value]];
}

- (NSString *)stringWithTitle:(NSString *)title stringValue:(NSString *)value {
    return [NSString stringWithFormat:@"%@ %@", title, value];
}

- (NSString *)stringWithBool:(BOOL)value {
    return value ? @"Yes" : @"No";
}

- (NSString *)stringWithDate:(NSDate *)date {
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
}

@end