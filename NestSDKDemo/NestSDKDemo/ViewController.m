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

@interface ViewController ()

@property(nonatomic) NestSDKDataManager *dataManager;

@end


@implementation ViewController

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
    [self.dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
        [self logMessage:@"Structures updated!"];

        // Structure may change while observing, so remove all current device observers and then set all new ones
        [self removeDevicesObservers];

        // Cycle through all structures and set observers for all devices
        for (NestSDKStructure *structure in structuresArray) {
            [self logMessage:[NSString stringWithFormat:@"Found structure: %@!", structure.name]];

            [self observeThermostatsWithinStructure:structure];
            [self observeSmokeCOAlarmsWithinStructure:structure];
            [self observeCamerasWithinStructure:structure];
        }
    }];
}

- (void)removeStructuresObservers {
    [self.dataManager removeAllObservers];
}

- (void)observeThermostatsWithinStructure:(NestSDKStructure *)structure {
    for (NSString *thermostatId in structure.thermostats) {
        [self.dataManager observeThermostatWithId:thermostatId block:^(NestSDKThermostat *thermostat, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing thermostat: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"Thermostat %@ updated! Current temperature in C: %.1f",
                                                            thermostat.name, thermostat.ambient_temperature_c]];
            }
        }];
    }
}

- (void)observeSmokeCOAlarmsWithinStructure:(NestSDKStructure *)structure {
    for (NSString *smokeCOAlarmId in structure.smokeCoAlarms) {
        [self.dataManager observeSmokeCOAlarmWithId:smokeCOAlarmId block:^(NestSDKSmokeCOAlarm *smokeCOAlarm, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing smokeCOAlarm: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"smokeCOAlarm %@ updated! Current state: %@",
                                                            smokeCOAlarm.name, smokeCOAlarm.co_alarm_state]];
            }
        }];
    }
}

- (void)observeCamerasWithinStructure:(NestSDKStructure *)structure {
    for (NSString *cameraId in structure.cameras) {
        [self.dataManager observeCameraWithId:cameraId block:^(NestSDKCamera *camera, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing camera: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"Camera %@ updated! Streaming state: %@",
                                                            camera.name, camera.is_streaming ? @"YES" : @"NO"]];
            }
        }];
    }
}

- (void)removeDevicesObservers {
    [self.dataManager removeAllObservers];
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
