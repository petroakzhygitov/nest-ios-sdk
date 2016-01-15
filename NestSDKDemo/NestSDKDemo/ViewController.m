//
//  ViewController.m
//  NestSDKDemo
//
//  Created by Petro Akzhygitov on 7/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <NestSDK/NestSDKAuthorizationManager.h>
#import <NestSDK/NestSDKAuthorizationManagerAuthorizationResult.h>
#import <NestSDK/NestSDKConnectWithNestButton.h>
#import <NestSDK/NestSDKDataManager.h>
#import <NestSDK/NestSDKStructure.h>
#import <NestSDK/NestSDKSmokeCOAlarm.h>
#import <NestSDK/NestSDKAccessToken.h>
#import <NestSDK/NestSDKCamera.h>
#import <NestSDK/NestSDKThermostat.h>
#import "ViewController.h"
#import "NestSDKCameraLastEventDataModel.h"
#import "NestSDKETADataModel.h"

@interface ViewController ()

@property(nonatomic) NestSDKDataManager *dataManager;

@end


@implementation ViewController {
    id<NestSDKThermostat> _thermostat;
    id<NestSDKStructure> _structure;
    id<NestSDKCamera> _camera;
}

- (IBAction)click:(id)sender {
//    _thermostat.targetTemperatureC = 32;
//
//    [self.dataManager setThermostat:_thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
//        NSLog(@"thermostat: %@", thermostat);
//        NSLog(@"error: %@", error);
//    }];
//
//    _camera.isStreaming = YES;
//
//    [self.dataManager setCamera:_camera block:^(id <NestSDKCamera> camera, NSError *error) {
//        NSLog(@"camera: %@", camera);
//        NSLog(@"error: %@", error);
//    }];

//    NestSDKETADataModel *model = [[NestSDKETADataModel alloc] init];
//    model.tripId = @"asdsad";
//    model.estimatedArrivalWindowBegin = [NSDate dateWithTimeInterval:2000 sinceDate:[NSDate date]];
//    model.estimatedArrivalWindowEnd = [NSDate dateWithTimeInterval:4000 sinceDate:[NSDate date]];
//    _structure.eta = model;
//    _structure.away = NestSDKStructureAwayStateHome;
//
//    [self.dataManager setStructure:_structure block:^(id <NestSDKStructure> structure, NSError *error) {
//        NSLog(@"structure: %@", structure);
//        NSLog(@"error: %@", error);
//    }];

    [self.dataManager metadataWithBlock:^(id <NestSDKMetadata> metadata, NSError *error) {
        if (error) {
            NSLog(@"Error occurred while reading metadata: %@", error);
            return;
        }

        NSLog(@"Read metadata: %@", metadata);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Connect with Nest using NestSDKConnectWithNestButton
    self.connectWithNestButton.delegate = self;

    // Connect with Nest using your custom button
//    [self createCustomConnectWithNestButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([NestSDKAccessToken currentAccessToken]) {
        [self observeStructures];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self removeObservers];
}


- (void)createCustomConnectWithNestButton {
    // Add a custom connect with button to your app
    UIButton *customConnectWithNestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customConnectWithNestButton.backgroundColor = [UIColor darkGrayColor];
    customConnectWithNestButton.frame = CGRectMake(0, 0, 240, 40);

    // Optional: Place the button in the center of your view.
    customConnectWithNestButton.center = self.view.center;
    [customConnectWithNestButton setTitle:@"Custom Connect Button" forState:UIControlStateNormal];

    // Handle clicks on the button
    [customConnectWithNestButton addTarget:self action:@selector(customConnectWithNestButtonClicked)
                          forControlEvents:UIControlEventTouchUpInside];

    // Add the button to the view
    [self.view addSubview:customConnectWithNestButton];
}

- (void)observeStructures {
    // Init manager
    self.dataManager = [[NestSDKDataManager alloc] init];

    // Start observing structures changes
    [self.dataManager structuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
        [self logMessage:@"Structures updated!"];

        // Structure may change while observing, so remove all current device observers and then set all new ones
        [self removeDevicesObservers];

        // Cycle through all structures and set observers for all devices
        for (id<NestSDKStructure> structure in structuresArray) {
            [self logMessage:[NSString stringWithFormat:@"Found structure: %@!", structure.name]];

            [self observeThermostatsWithinStructure:structure];
            [self observeSmokeCOAlarmsWithinStructure:structure];
            [self observeCamerasWithinStructure:structure];

            _structure = structure;
        }
    }];
}

- (void)removeStructuresObservers {
    [self.dataManager removeAllObservers];
}

- (void)observeThermostatsWithinStructure:(id<NestSDKStructure>)structure {
    for (NSString *thermostatId in structure.thermostats) {
        [self.dataManager thermostatWithId:thermostatId block:^(id <NestSDKThermostat> thermostat, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing thermostat: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"Thermostat %@ updated! Current temperature in C: %.1f",
                                                            thermostat.name, thermostat.ambientTemperatureC]];
                
                _thermostat = thermostat;
            }
        }];
    }
}

- (void)observeSmokeCOAlarmsWithinStructure:(id<NestSDKStructure>)structure {
    for (NSString *smokeCOAlarmId in structure.smokeCoAlarms) {
        [self.dataManager smokeCOAlarmWithId:smokeCOAlarmId block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing smokeCOAlarm: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"smokeCOAlarm %@ updated! Current state: %d",
                                                            smokeCOAlarm.name, smokeCOAlarm.coAlarmState]];
            }
        }];
    }
}

- (void)observeCamerasWithinStructure:(id<NestSDKStructure>)structure {
    for (NSString *cameraId in structure.cameras) {
        [self.dataManager cameraWithId:cameraId block:^(id <NestSDKCamera> camera, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing camera: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"Camera %@ updated! Streaming state: %@",
                                                            camera.name, camera.isStreaming ? @"YES" : @"NO"]];

                _camera = camera;
            }
        }];
    }
}

- (void)removeDevicesObservers {
//    [self.dataManager removeAllObservers];
}

- (void)removeObservers {
    [self removeDevicesObservers];
    [self removeStructuresObservers];
}

- (void)logMessage:(NSString *)message {
    self.nestInfoTextView.text = [self.nestInfoTextView.text stringByAppendingFormat:@"%@\n", message];
}

- (void)handleAuthorizationResult:(NestSDKAuthorizationManagerAuthorizationResult *)result error:(NSError *)error {
    if (error) {
        NSLog(@"Process error: %@", error);

    } else if (result.isCancelled) {
        NSLog(@"Cancelled");

    } else {
        NSLog(@"Authorized!");

        [self observeStructures];
    }
}

// Once the button is clicked, show the auth dialog
- (void)customConnectWithNestButtonClicked {
    NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];
    [authorizationManager authorizeWithNestAccountFromViewController:self
                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                 [self handleAuthorizationResult:result error:error];
                                                             }];
}

- (void)connectWithNestButton:(NestSDKConnectWithNestButton *)loginButton
        didCompleteWithResult:(NestSDKAuthorizationManagerAuthorizationResult *)result
                        error:(NSError *)error {

    [self handleAuthorizationResult:result error:error];
}

- (void)loginButtonDidLogOut:(NestSDKConnectWithNestButton *)loginButton {
    [self removeObservers];
}


@end
