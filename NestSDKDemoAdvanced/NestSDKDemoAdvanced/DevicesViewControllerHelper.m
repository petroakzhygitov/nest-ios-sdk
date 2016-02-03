#import <NestSDK/NestSDKStructure.h>
#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import <NestSDK/NestSDKThermostat.h>
#import <NestSDK/NestSDKCamera.h>
#import "DevicesViewControllerHelper.h"
#import "ThermostatViewCell.h"
#import "ThermostatViewModel.h"
#import "SmokeCOAlarmViewCell.h"
#import "SmokeCOAlarmIconView.h"
#import "CameraViewCell.h"
#import "SmokeCOAlarmViewModel.h"
#import "CameraViewModel.h"
#import "CameraIconView.h"
#import "DeviceDetailsViewController.h"

#pragma mark const

static NSString *const kViewCellIdentifierThermostat = @"ThermostatViewCellIdentifier";
static NSString *const kViewCellIdentifierSmokeCOAlarm = @"SmokeCOAlarmViewCellIdentifier";
static NSString *const kViewCellIdentifierCamera = @"CameraViewCellIdentifier";

static NSString *const kSegueIdentifierThermostatDetails = @"ThermostatDetailsSegueIdentifier";
static NSString *const kSegueIdentifierSmokeCOAlarmDetails = @"SmokeCOAlarmDetailsSegueIdentifier";
static NSString *const kSegueIdentifierCameraDetails = @"CameraDetailsSegueIdentifier";


@implementation DevicesViewControllerHelper
#pragma mark Private

+ (void)_populateThermostatCell:(ThermostatViewCell *)cell withThermostat:(id <NestSDKThermostat>)thermostat {
    ThermostatViewModel *viewModel = [ThermostatViewModel viewModelWithThermostat:thermostat];

    cell.nameLabel.text = viewModel.nameLongText;
    cell.energySavingLabel.text = viewModel.energySavingText;
    cell.iconView.state = viewModel.iconViewState;
    cell.iconView.targetTemperature = viewModel.iconViewTargetTemperature;
}

+ (void)_populateSmokeCOAlarmCell:(SmokeCOAlarmViewCell *)cell withSmokeCOAlarm:(id <NestSDKSmokeCOAlarm>)smokeCOAlarm {
    SmokeCOAlarmViewModel *viewModel = [SmokeCOAlarmViewModel viewModelWithSmokeCOAlarm:smokeCOAlarm];

    cell.nameLabel.text = viewModel.nameLongText;
    cell.batteryStatusLabel.text = viewModel.batteryStatusText;
    cell.iconView.color = viewModel.iconViewColor;
}

+ (void)_populateCameraCell:(CameraViewCell *)cell withCamera:(id <NestSDKCamera>)camera {
    CameraViewModel *viewModel = [CameraViewModel viewModelWithCamera:camera];

    cell.nameLabel.text = viewModel.nameLongText;
    cell.statusLabel.text = viewModel.connectionStatusText;
    cell.iconView.streaming = viewModel.streaming;
}

+ (BOOL)_isThermostatIndex:(NSInteger)index forStructure:(id <NestSDKStructure>)structure {
    return index >= 0 && index < structure.thermostats.count;
}

+ (BOOL)_isSmokeCOAlarmIndex:(NSInteger)index forStructure:(id <NestSDKStructure>)structure {
    index = [self _smokeCOAlarmIndexWithDeviceIndex:index forStructure:structure];
    return index >= 0 && index < structure.smokeCoAlarms.count;
}

+ (BOOL)_isCameraIndex:(NSInteger)index forStructure:(id <NestSDKStructure>)structure {
    index = [self _cameraIndexWithDeviceIndex:index forStructure:structure];
    return index >= 0 && index < structure.cameras.count;
}

+ (NSUInteger)_smokeCOAlarmIndexWithDeviceIndex:(NSInteger)deviceIndex forStructure:(id <NestSDKStructure>)structure {
    return deviceIndex - structure.thermostats.count;
}

+ (NSUInteger)_cameraIndexWithDeviceIndex:(NSInteger)deviceIndex forStructure:(id <NestSDKStructure>)structure {
    return deviceIndex - structure.thermostats.count - structure.smokeCoAlarms.count;
}

+ (BOOL)_device:(id <NestSDKDevice>)device conformsProtocol:(Protocol *)aProtocol {
    return [[device class] conformsToProtocol:aProtocol];
}

#pragma mark Public

+ (void)populateCell:(UITableViewCell *)cell withDevice:(id <NestSDKDevice>)device {
    if ([cell isKindOfClass:[ThermostatViewCell class]]) {
        [self _populateThermostatCell:(ThermostatViewCell *) cell withThermostat:(id <NestSDKThermostat>) device];

    } else if ([cell isKindOfClass:[SmokeCOAlarmViewCell class]]) {
        [self _populateSmokeCOAlarmCell:(SmokeCOAlarmViewCell *) cell withSmokeCOAlarm:(id <NestSDKSmokeCOAlarm>) device];

    } else if ([cell isKindOfClass:[CameraViewCell class]]) {
        [self _populateCameraCell:(CameraViewCell *) cell withCamera:(id <NestSDKCamera>) device];
    }
}

+ (void)passDevice:(id <NestSDKDevice>)device toViewController:(UIViewController *)controller {
    ((DeviceDetailsViewController *) controller).device = device;
}

+ (NSUInteger)devicesForStructure:(id <NestSDKStructure>)structure {
    return structure.thermostats.count + structure.smokeCoAlarms.count + structure.cameras.count;
}

+ (NSString *)cellIdentifierWithStructure:(id <NestSDKStructure>)structure deviceIndex:(NSUInteger)deviceIndex {
    if ([self _isThermostatIndex:deviceIndex forStructure:structure]) {
        return kViewCellIdentifierThermostat;

    } else if ([self _isSmokeCOAlarmIndex:deviceIndex forStructure:structure]) {
        return kViewCellIdentifierSmokeCOAlarm;

    } else if ([self _isCameraIndex:deviceIndex forStructure:structure]) {
        return kViewCellIdentifierCamera;
    }

    return nil;
}

+ (NSString *)segueIdentifierWithStructure:(id <NestSDKStructure>)structure deviceIndex:(NSUInteger)deviceIndex {
    if ([self _isThermostatIndex:deviceIndex forStructure:structure]) {
        return kSegueIdentifierThermostatDetails;

    } else if ([self _isSmokeCOAlarmIndex:deviceIndex forStructure:structure]) {
        return kSegueIdentifierSmokeCOAlarmDetails;

    } else if ([self _isCameraIndex:deviceIndex forStructure:structure]) {
        return kSegueIdentifierCameraDetails;
    }

    return nil;
}

+ (NSString *)deviceIdWithIndex:(NSUInteger)deviceIndex forStructure:(id <NestSDKStructure>)structure {
    NSString *deviceId = nil;

    if ([self _isThermostatIndex:deviceIndex forStructure:structure]) {
        deviceId = structure.thermostats[(NSUInteger) deviceIndex];

    } else if ([self _isSmokeCOAlarmIndex:deviceIndex forStructure:structure]) {
        deviceIndex = [self _smokeCOAlarmIndexWithDeviceIndex:deviceIndex forStructure:structure];
        deviceId = structure.smokeCoAlarms[(NSUInteger) deviceIndex];

    } else if ([self _isCameraIndex:deviceIndex forStructure:structure]) {
        deviceIndex -= structure.thermostats.count + structure.smokeCoAlarms.count;
        deviceId = structure.cameras[(NSUInteger) deviceIndex];
    }

    return deviceId;
}

@end