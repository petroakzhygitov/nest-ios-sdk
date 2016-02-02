//
//  DevicesViewController.m
//  NestSDKDemoAdvanced
//
//  Created by Petro Akzhygitov on 14/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <NestSDK/NestSDK.h>
#import <NestSDK/NestSDKMacroses.h>
#import "DevicesViewController.h"
#import "ThermostatViewCell.h"
#import "SmokeCOAlarmViewCell.h"
#import "CameraViewCell.h"
#import "SmokeCOAlarmIconView.h"
#import "ThermostatIconView.h"
#import "CameraIconView.h"

static NSString *const kViewCellIdentifierThermostat = @"ThermostatViewCellIdentifier";
static NSString *const kViewCellIdentifierSmokeCOAlarm = @"SmokeCOAlarmViewCellIdentifier";
static NSString *const kViewCellIdentifierCamera = @"CameraViewCellIdentifier";

static const int kHeightForRow = 88;


@interface DevicesViewController ()

@property(nonatomic) NestSDKDataManager *dataManager;
@property(nonatomic) NSMutableArray *deviceObserverHandles;

@property(nonatomic) NestSDKObserverHandle structuresObserverHandle;

@property(nonatomic, strong) NSArray <NestSDKStructure> *structuresArray;
@property(nonatomic, strong) NSMutableDictionary *devicesDictionary;

@property(nonatomic, copy) void (^deviceUpdateHandlerBlock)(id <NestSDKDevice>, NSError *);

@end


@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _initDeviceUpdateHandlerBlock];
    [self _initUI];

    if ([NestSDKAccessToken currentAccessToken]) {
        [self observeStructures];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![NestSDKAccessToken currentAccessToken]) {
        [self _showConnectWithNestView];
    }
}

- (void)dealloc {
    [self removeObservers];
}

- (void)_initDeviceUpdateHandlerBlock {
    @weakify(self)
    self.deviceUpdateHandlerBlock = ^(id <NestSDKDevice> device, NSError *error) {
        @strongify(self)
        if (!self) return;

        if (error) {
            NSLog(@"Error occurred while observing device %@: %@", device.deviceId, error);
            return;
        }

        [self _addDevice:device];
    };
}

- (void)_initUI {
    self.title = @"Devices";

    [self _initTableView];

    self.dataManager = [[NestSDKDataManager alloc] init];
    self.deviceObserverHandles = [[NSMutableArray alloc] init];
}

- (void)_initTableView {
    self.tableView.estimatedRowHeight = kHeightForRow;
    self.tableView.estimatedSectionHeaderHeight = 30;
    self.tableView.estimatedSectionFooterHeight = 0;

//    self.tableView.allowsSelection = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}

- (void)_showConnectWithNestView {
    self.faderView.hidden = NO;
    self.connectWithNestView.hidden = NO;
}

- (void)_hideConnectWithNestView {
    self.faderView.hidden = YES;
    self.connectWithNestView.hidden = YES;
}

- (void)observeStructures {
    // Clean up previous observers
    [self removeObservers];

    // Start observing structures
    self.structuresObserverHandle = [self.dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
        // Structure may change while observing, so remove all current device observers and then set all new ones
        [self removeDevicesObservers];

        self.structuresArray = structuresArray;
        self.devicesDictionary = [[NSMutableDictionary alloc] init];

        // Cycle through all structures and set observers for all devices
        for (id <NestSDKStructure> structure in structuresArray) {
            [self _observeThermostatsWithinStructure:structure];
            [self _observeSmokeCOAlarmsWithinStructure:structure];
            [self _observeCamerasWithinStructure:structure];
        }

        [self _reloadData];
    }];
}

- (void)_observeThermostatsWithinStructure:(id <NestSDKStructure>)structure {
    for (NSString *thermostatId in structure.thermostats) {
        [self.dataManager observeThermostatWithId:thermostatId block:(NestSDKThermostatUpdateHandler) self.deviceUpdateHandlerBlock];
    }
}

- (void)_observeSmokeCOAlarmsWithinStructure:(id <NestSDKStructure>)structure {
    for (NSString *smokeCOAlarmId in structure.smokeCoAlarms) {
        [self.dataManager observeSmokeCOAlarmWithId:smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler) self.deviceUpdateHandlerBlock];
    }
}

- (void)_observeCamerasWithinStructure:(id <NestSDKStructure>)structure {
    for (NSString *cameraId in structure.cameras) {
        [self.dataManager observeCameraWithId:cameraId block:(NestSDKCameraUpdateHandler) self.deviceUpdateHandlerBlock];
    }
}

- (void)_addDevice:(id <NestSDKDevice>)device {
    self.devicesDictionary[device.deviceId] = device;

    [self _reloadData];
}

- (void)_reloadData {
    [self.tableView reloadData];
}

- (void)removeObservers {
    [self removeDevicesObservers];
    [self removeStructuresObservers];
}

- (void)removeDevicesObservers {
    for (NSNumber *handle in self.deviceObserverHandles) {
        [self.dataManager removeObserverWithHandle:handle.unsignedIntegerValue];
    }

    [self.deviceObserverHandles removeAllObjects];
}

- (void)removeStructuresObservers {
    [self.dataManager removeObserverWithHandle:self.structuresObserverHandle];
}

- (NSUInteger)_devicesForStructure:(id <NestSDKStructure>)structure {
    return structure.thermostats.count + structure.smokeCoAlarms.count + structure.cameras.count;
}

- (NSString *)_cellIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    id <NestSDKStructure> structure = [self _structureWithSection:(NSUInteger) indexPath.section];
    NSString *cellIdentifier = [self _cellIdentifierWithStructure:structure deviceIndex:(NSUInteger) indexPath.row];

    return cellIdentifier;
}

- (id <NestSDKStructure>)_structureWithSection:(NSUInteger)section {
    id <NestSDKStructure> structure = self.structuresArray[section];

    return structure;
}

- (NSString *)_cellIdentifierWithStructure:(id <NestSDKStructure>)structure deviceIndex:(NSUInteger)deviceIndex {
    if ([self _isThermostatIndex:deviceIndex forStructure:structure]) {
        return kViewCellIdentifierThermostat;

    } else if ([self _isSmokeCOAlarmIndex:deviceIndex forStructure:structure]) {
        return kViewCellIdentifierSmokeCOAlarm;

    } else if ([self _isCameraIndex:deviceIndex forStructure:structure]) {
        return kViewCellIdentifierCamera;
    }

    return nil;
}

- (NSString *)_segueIdentifierWithStructure:(id <NestSDKStructure>)structure deviceIndex:(NSUInteger)deviceIndex {
    if ([self _isThermostatIndex:deviceIndex forStructure:structure]) {
        return @"ThermostatDetailsSegueIdentifier";

    } else if ([self _isSmokeCOAlarmIndex:deviceIndex forStructure:structure]) {
        return @"SmokeCOAlarmDetailsSegueIdentifier";

    } else if ([self _isCameraIndex:deviceIndex forStructure:structure]) {
        return @"CameraDetailsSegueIdentifier";
    }

    return nil;
}

- (id <NestSDKSmokeCOAlarm>)_deviceWithIndex:(NSUInteger)deviceIndex forStructure:(id <NestSDKStructure>)structure {
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

    return self.devicesDictionary[deviceId];
}

- (BOOL)_isThermostatIndex:(NSInteger)index forStructure:(id <NestSDKStructure>)structure {
    return index >= 0 && index < structure.thermostats.count;
}

- (BOOL)_isSmokeCOAlarmIndex:(NSInteger)index forStructure:(id <NestSDKStructure>)structure {
    index = [self _smokeCOAlarmIndexWithDeviceIndex:index forStructure:structure];
    return index >= 0 && index < structure.smokeCoAlarms.count;
}

- (BOOL)_isCameraIndex:(NSInteger)index forStructure:(id <NestSDKStructure>)structure {
    index = [self _cameraIndexWithDeviceIndex:index forStructure:structure];
    return index >= 0 && index < structure.cameras.count;
}

- (NSUInteger)_smokeCOAlarmIndexWithDeviceIndex:(NSInteger)deviceIndex forStructure:(id <NestSDKStructure>)structure {
    return deviceIndex - structure.thermostats.count;
}

- (NSUInteger)_cameraIndexWithDeviceIndex:(NSInteger)deviceIndex forStructure:(id <NestSDKStructure>)structure {
    return deviceIndex - structure.thermostats.count - structure.smokeCoAlarms.count;
}

- (UIColor *)_colorWithUIColorState:(NestSDKSmokeCOAlarmUIColorState)state {
    switch (state) {
        case NestSDKSmokeCOAlarmUIColorStateUndefined:
            return nil;

        case NestSDKSmokeCOAlarmUIColorStateGray:
            return [UIColor grayColor];

        case NestSDKSmokeCOAlarmUIColorStateGreen:
            return [UIColor greenColor];

        case NestSDKSmokeCOAlarmUIColorStateYellow:
            return [UIColor yellowColor];

        case NestSDKSmokeCOAlarmUIColorStateRed:
            return [UIColor redColor];
    }

    return nil;
}

- (CGFloat)_targetTemperatureWithThermostat:(id <NestSDKThermostat>)thermostat {
    switch (thermostat.temperatureScale) {
        case NestSDKThermostatTemperatureScaleC:
            return thermostat.targetTemperatureC;

        case NestSDKThermostatTemperatureScaleF:
            return thermostat.targetTemperatureF;

        case NestSDKThermostatTemperatureScaleUndefined:
            return 0;
    }

    return 0;
}

- (NSString *)_energySavingStringWithThermostat:(id <NestSDKThermostat>)thermostat {
    return [NSString stringWithFormat:@"Energy saving: %@", thermostat.hasLeaf ? @"Yes" : @"No"];
}

- (NSString *)_statusStringWithCamera:(id <NestSDKCamera>)camera {
    return [NSString stringWithFormat:@"Status: %@", camera.isOnline ? @"Online" : @"Offline"];
}

- (NSString *)_batteryHealthStringWithSmokeCOAlarm:(id <NestSDKSmokeCOAlarm>)smokeCOAlarm {
    NSString *batteryHealthString = @"Undefined";

    switch (smokeCOAlarm.batteryHealth) {
        case NestSDKSmokeCOAlarmBatteryHealthUndefined:
            batteryHealthString = @"Undefined";

            break;
        case NestSDKSmokeCOAlarmBatteryHealthOk:
            batteryHealthString = @"OK";

            break;
        case NestSDKSmokeCOAlarmBatteryHealthReplace:
            batteryHealthString = @"Replace";

            break;
    }

    return [NSString stringWithFormat:@"Battery health: %@", batteryHealthString];
}

- (ThermostatIconViewState)_thermostatIconViewStateWithThermostat:(id <NestSDKThermostat>)thermostat {
    switch (thermostat.hvacState) {
        case NestSDKThermostatHVACStateUndefined:
        case NestSDKThermostatHVACStateOff:
            return ThermostatIconViewStateOff;

        case NestSDKThermostatHVACStateHeating:
            return ThermostatIconViewStateHeating;

        case NestSDKThermostatHVACStateCooling:
            return ThermostatIconViewStateCooling;
    }

    return ThermostatIconViewStateOff;
}

#pragma mark Delegate <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.structuresArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self _devicesForStructure:self.structuresArray[(NSUInteger) section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self _cellIdentifierWithIndexPath:indexPath];

    return [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NestSDKStructure> structure = self.structuresArray[(NSUInteger) section];

    return structure.name;
}

#pragma mark Delegate <UITableViewDelegate>

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id <NestSDKStructure> structure = [self _structureWithSection:(NSUInteger) indexPath.section];
    id <NestSDKDevice> device = [self _deviceWithIndex:(NSUInteger) indexPath.row forStructure:structure];

    if ([cell isKindOfClass:[ThermostatViewCell class]]) {
        id <NestSDKThermostat> thermostat = (id <NestSDKThermostat>) device;

        ThermostatViewCell *thermostatViewCell = (ThermostatViewCell *) cell;
        thermostatViewCell.nameLabel.text = thermostat.nameLong;
        thermostatViewCell.energySavingLabel.text = [self _energySavingStringWithThermostat:thermostat];
        thermostatViewCell.iconView.state = [self _thermostatIconViewStateWithThermostat:thermostat];
        thermostatViewCell.iconView.targetTemperature = [self _targetTemperatureWithThermostat:thermostat];

    } else if ([cell isKindOfClass:[SmokeCOAlarmViewCell class]]) {
        id <NestSDKSmokeCOAlarm> smokeCOAlarm = (id <NestSDKSmokeCOAlarm>) device;

        SmokeCOAlarmViewCell *smokeCOAlarmViewCell = (SmokeCOAlarmViewCell *) cell;
        smokeCOAlarmViewCell.nameLabel.text = smokeCOAlarm.nameLong;
        smokeCOAlarmViewCell.batteryStatusLabel.text = [self _batteryHealthStringWithSmokeCOAlarm:smokeCOAlarm];
        smokeCOAlarmViewCell.iconView.color = SmokeCOAlarmIconViewColorGreen;

    } else if ([cell isKindOfClass:[CameraViewCell class]]) {
        id <NestSDKCamera> camera = (id <NestSDKCamera>) device;

        CameraViewCell *cameraViewCell = (CameraViewCell *) cell;
        cameraViewCell.nameLabel.text = camera.nameLong;
        cameraViewCell.statusLabel.text = [self _statusStringWithCamera:camera];
        cameraViewCell.iconView.streaming = camera.isStreaming;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id <NestSDKStructure> structure = [self _structureWithSection:(NSUInteger) indexPath.section];
    NSString *segueIdentifier = [self _segueIdentifierWithStructure:structure deviceIndex:(NSUInteger) indexPath.row];

    [self performSegueWithIdentifier:segueIdentifier sender:self];
}

#pragma mark Delegate <NestSDKConnectWithNestButtonDelegate>

- (void)connectWithNestButton:(NestSDKConnectWithNestButton *)connectWithNestButton didAuthorizeWithResult:(NestSDKAuthorizationManagerAuthorizationResult *)result error:(NSError *)error {
    if (error) {
        NSLog(@"Process error: %@", error);

    } else if (result.isCancelled) {
        NSLog(@"Cancelled");

    } else {
        NSLog(@"Authorized!");

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self _hideConnectWithNestView];
        });

        [self observeStructures];
    }
}

- (void)connectWithNestButtonDidUnauthorize:(NestSDKConnectWithNestButton *)connectWithNestButton {

}

@end