//
//  ViewController.m
//  NestSDKDemoAdvanced
//
//  Created by Petro Akzhygitov on 14/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <NestSDK/NestSDKConnectWithNestButton.h>
#import "ViewController.h"
#import "NestSDKAccessToken.h"
#import "NestSDKDataManager.h"
#import "NestSDKStructure.h"
#import "NestSDKAuthorizationManagerAuthorizationResult.h"
#import "ThermostatViewCell.h"
#import "SmokeCOAlarmViewCell.h"
#import "CameraViewCell.h"


static NSString *const kViewCellIdentifierThermostat = @"ViewCellIdentifierThermostat";
static NSString *const kViewCellIdentifierSmokeCOAlarm = @"ViewCellIdentifierSmokeCOAlarm";
static NSString *const kViewCellIdentifierCamera = @"ViewCellIdentifierCamera";


@interface ViewController ()

@property(nonatomic, strong) NestSDKDataManager *dataManager;
@property(nonatomic, strong) NSArray <NestSDKStructure> *structuresArray;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _initUI];
}

- (void)_initUI {
    [self _initTableView];

    self.connectWithNestButton.delegate = self;
}

- (void)_initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ThermostatViewCell class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kViewCellIdentifierThermostat];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SmokeCOAlarmViewCell class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kViewCellIdentifierSmokeCOAlarm];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CameraViewCell class]) bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kViewCellIdentifierCamera];

    self.tableView.estimatedRowHeight = 100;
    self.tableView.estimatedSectionHeaderHeight = 30;
    self.tableView.estimatedSectionFooterHeight = 0;

    self.tableView.allowsSelection = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([NestSDKAccessToken currentAccessToken]) {
        [self observeStructures];

    } else {
        [self _showConnectWithNestView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self removeObservers];
}

- (void)_showConnectWithNestView {
    self.navigationController.navigationBar.layer.zPosition = -1;

    self.faderView.hidden = NO;
    self.connectWithNestView.hidden = NO;
}

- (void)_hideConnectWithNestView {
    self.faderView.hidden = YES;
    self.connectWithNestView.hidden = YES;

    self.navigationController.navigationBar.layer.zPosition = 0;
}

- (void)observeStructures {
    // Init manager
    self.dataManager = [[NestSDKDataManager alloc] init];

    // Start observing structures changes
    [self.dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
        // Structure may change while observing, so remove all current device observers and then set all new ones
        [self removeDevicesObservers];

        self.structuresArray = structuresArray;

        // Cycle through all structures and set observers for all devices
        for (NestSDKStructure *structure in structuresArray) {
            [self observeThermostatsWithinStructure:structure];
            [self observeSmokeCOAlarmsWithinStructure:structure];
            [self observeCamerasWithinStructure:structure];
        }
    }];
}

- (void)observeThermostatsWithinStructure:(NestSDKStructure *)structure {
    for (NSString *thermostatId in structure.thermostats) {
        [self.dataManager observeThermostatWithId:thermostatId block:^(NestSDKThermostat *thermostat, NSError *error) {
            if (error) {

            } else {
            }
        }];
    }
}

- (void)observeSmokeCOAlarmsWithinStructure:(NestSDKStructure *)structure {
    for (NSString *smokeCOAlarmId in structure.smokeCoAlarms) {
        [self.dataManager observeSmokeCOAlarmWithId:smokeCOAlarmId block:^(NestSDKSmokeCOAlarm *smokeCOAlarm, NSError *error) {
            if (error) {

            } else {
            }
        }];
    }
}

- (void)observeCamerasWithinStructure:(NestSDKStructure *)structure {
    for (NSString *cameraId in structure.cameras) {
        [self.dataManager observeCameraWithId:cameraId block:^(NestSDKCamera *camera, NSError *error) {
            if (error) {

            } else {
            }
        }];
    }
}

- (void)removeDevicesObservers {
//    [self.dataManager removeAllObservers];
}

- (void)removeStructuresObservers {
    [self.dataManager removeAllObservers];
}

- (void)removeObservers {
    [self removeDevicesObservers];
    [self removeStructuresObservers];
}

- (NSUInteger)_devicesForStructure:(NestSDKStructure *)structure {
    return structure.thermostats.count + structure.smokeCoAlarms.count + structure.cameras.count;
}

- (NSString *)_reusableCellIdentifierWithStructure:(NestSDKStructure *)structure deviceIndex:(NSUInteger)deviceIndex {
    if (structure.thermostats.count > deviceIndex) {
        return kViewCellIdentifierThermostat;

    } else if (structure.smokeCoAlarms.count > deviceIndex - structure.thermostats.count) {
        return kViewCellIdentifierSmokeCOAlarm;
    }

    return kViewCellIdentifierCamera;
}


- (void)connectWithNestButton:(NestSDKConnectWithNestButton *)loginButton
        didCompleteWithResult:(NestSDKAuthorizationManagerAuthorizationResult *)result
                        error:(NSError *)error {

    if (error) {
        NSLog(@"Process error: %@", error);

    } else if (result.isCancelled) {
        NSLog(@"Cancelled");

    } else {
        NSLog(@"Authorized!");

        [self _hideConnectWithNestView];
        [self observeStructures];
    }
}

#pragma mark Delegate <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.structuresArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self _devicesForStructure:self.structuresArray[(NSUInteger) section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NestSDKStructure *structure = self.structuresArray[(NSUInteger) indexPath.section];
    NSString *cellIdentifier = [self _reusableCellIdentifierWithStructure:structure deviceIndex:(NSUInteger) indexPath.row];

    return [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NestSDKStructure *structure = self.structuresArray[(NSUInteger) section];

    return structure.name;
}

#pragma mark Delegate <UITableViewDelegate>

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ThermostatViewCell class]]) {
        ThermostatViewCell *thermostatViewCell = (ThermostatViewCell *) cell;

    } else if ([cell isKindOfClass:[SmokeCOAlarmViewCell class]]) {
        SmokeCOAlarmViewCell *smokeCOAlarmViewCell = (SmokeCOAlarmViewCell *) cell;

    } else if ([cell isKindOfClass:[CameraViewCell class]]) {
        CameraViewCell *cameraViewCell = (CameraViewCell *) cell;
    }
}


@end
