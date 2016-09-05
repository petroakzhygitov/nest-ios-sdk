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
#import "DevicesViewControllerHelper.h"

static const int kHeightForRow = 88;
static const int kHeightForHeaderInSection = 30;
static const int kHeightForFooterInSection = 20;

@interface DevicesViewController ()

@property(nonatomic) NestSDKDataManager *dataManager;

@property(nonatomic) NSMutableArray *deviceObserverHandles;
@property(nonatomic) NestSDKObserverHandle structuresObserverHandle;

@property(nonatomic) NSArray <NestSDKStructure> *structuresArray;
@property(nonatomic) NSMutableDictionary *devicesDictionary;

@property(nonatomic, copy) void (^deviceUpdateHandlerBlock)(id <NestSDKDevice>, NSError *);

@property(nonatomic) id <NestSDKDevice> selectedDevice;

@end


@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _init];

    if ([self _isAuthorized]) {
        [self _observeStructures];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![self _isAuthorized]) {
        [self _showConnectWithNestView];
    }
}

- (void)dealloc {
    [self _removeObservers];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [DevicesViewControllerHelper passDevice:self.selectedDevice toViewController:[segue destinationViewController]];
}

- (void)_init {
    [self _initProperties];
    [self _initDeviceUpdateHandlerBlock];
    [self _initTableView];
}

- (void)_initProperties {
    self.dataManager = [[NestSDKDataManager alloc] init];
    self.deviceObserverHandles = [[NSMutableArray alloc] init];

    self.title = @"Devices";
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

        [self _updateDevice:device];
    };
}

- (void)_initTableView {
    [DevicesViewControllerHelper registerReusableCellsForTableView:self.tableView];

    self.tableView.rowHeight = kHeightForRow;
    self.tableView.sectionHeaderHeight = kHeightForHeaderInSection;
    self.tableView.sectionFooterHeight = kHeightForFooterInSection;
}

- (BOOL)_isAuthorized {
    return [NestSDKAccessToken currentAccessToken] != nil;
}

- (void)_showConnectWithNestView {
    self.faderView.hidden = NO;
    self.connectWithNestView.hidden = NO;
}

- (void)_hideConnectWithNestView {
    self.faderView.hidden = YES;
    self.connectWithNestView.hidden = YES;
}

- (void)_observeStructures {
    // Clean up previous observers
    [self _removeObservers];

    // Start observing structures
    self.structuresObserverHandle = [self.dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
        // Structure may change while observing, so remove all current device observers and then set all new ones
        [self _removeDevicesObservers];

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

- (void)_updateDevice:(id <NestSDKDevice>)device {
    self.devicesDictionary[device.deviceId] = device;

    [self _reloadData];
}

- (void)_reloadData {
    [self.tableView reloadData];
}

- (void)_removeObservers {
    [self _removeDevicesObservers];
    [self _removeStructuresObservers];
}

- (void)_removeDevicesObservers {
    for (NSNumber *handle in self.deviceObserverHandles) {
        [self.dataManager removeObserverWithHandle:handle.unsignedIntegerValue];
    }

    [self.deviceObserverHandles removeAllObjects];
}

- (void)_removeStructuresObservers {
    [self.dataManager removeObserverWithHandle:self.structuresObserverHandle];
}

- (NSString *)_cellIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    id <NestSDKStructure> structure = [self _structureWithSection:(NSUInteger) indexPath.section];

    return [DevicesViewControllerHelper cellIdentifierWithStructure:structure deviceIndex:(NSUInteger) indexPath.row];
}

- (id <NestSDKStructure>)_structureWithSection:(NSUInteger)section {
    return self.structuresArray[section];
}

- (id <NestSDKDevice>)_deviceWithIndex:(NSUInteger)deviceIndex forStructure:(id <NestSDKStructure>)structure {
    NSString *deviceId = [DevicesViewControllerHelper deviceIdWithIndex:deviceIndex forStructure:structure];

    return self.devicesDictionary[deviceId];
}

#pragma mark Delegate <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.structuresArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DevicesViewControllerHelper devicesForStructure:self.structuresArray[(NSUInteger) section]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeightForHeaderInSection;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id <NestSDKStructure> structure = [self _structureWithSection:(NSUInteger) indexPath.section];
    id <NestSDKDevice> device = [self _deviceWithIndex:(NSUInteger) indexPath.row forStructure:structure];

    [DevicesViewControllerHelper populateCell:cell withDevice:device];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id <NestSDKStructure> structure = [self _structureWithSection:(NSUInteger) indexPath.section];

    self.selectedDevice = [self _deviceWithIndex:(NSUInteger) indexPath.row forStructure:structure];

    NSString *segueIdentifier = [DevicesViewControllerHelper segueIdentifierWithStructure:structure deviceIndex:(NSUInteger) indexPath.row];
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

        [self _observeStructures];
    }
}

- (void)connectWithNestButtonDidUnauthorize:(NestSDKConnectWithNestButton *)connectWithNestButton {
    NSLog(@"Unauthorized!");

    [self _removeObservers];
}

@end