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
@property(nonatomic) NSMutableArray *deviceObserverHandles;

@property(nonatomic) NestSDKObserverHandle structuresObserverHandle;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataManager = [[NestSDKDataManager alloc] init];
    self.deviceObserverHandles = [[NSMutableArray alloc] init];
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

- (void)observeStructures {
    // Clean up previous observers
    [self removeObservers];

    // Start observing structures
    self.structuresObserverHandle = [self.dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
        [self logMessage:@"Structures updated!"];

        // Structure may change while observing, so remove all current device observers and then set all new ones
        [self removeDevicesObservers];

        // Cycle through all structures and set observers for all devices
        for (id <NestSDKStructure> structure in structuresArray) {
            [self logMessage:[NSString stringWithFormat:@"Found structure: %@!", structure.name]];

            [self observeThermostatsWithinStructure:structure];
            [self observeSmokeCOAlarmsWithinStructure:structure];
            [self observeCamerasWithinStructure:structure];
        }
    }];
}

- (void)observeThermostatsWithinStructure:(id <NestSDKStructure>)structure {
    for (NSString *thermostatId in structure.thermostats) {
        NestSDKObserverHandle handle = [self.dataManager observeThermostatWithId:thermostatId block:^(id <NestSDKThermostat> thermostat, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing thermostat: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"Thermostat %@ updated! Current temperature in C: %.1f",
                                                            thermostat.name, thermostat.ambientTemperatureC]];
            }
        }];

        [self.deviceObserverHandles addObject:@(handle)];
    }
}

- (void)observeSmokeCOAlarmsWithinStructure:(id <NestSDKStructure>)structure {
    for (NSString *smokeCOAlarmId in structure.smokeCoAlarms) {
        NestSDKObserverHandle handle = [self.dataManager observeSmokeCOAlarmWithId:smokeCOAlarmId block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing smokeCOAlarm: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"smokeCOAlarm %@ updated! Current state: %lul",
                                  smokeCOAlarm.name, (unsigned long)smokeCOAlarm.coAlarmState]];
            }
        }];

        [self.deviceObserverHandles addObject:@(handle)];
    }
}

- (void)observeCamerasWithinStructure:(id <NestSDKStructure>)structure {
    for (NSString *cameraId in structure.cameras) {
        NestSDKObserverHandle handle = [self.dataManager observeCameraWithId:cameraId block:^(id <NestSDKCamera> camera, NSError *error) {
            if (error) {
                [self logMessage:[NSString stringWithFormat:@"Error observing camera: %@", error]];

            } else {
                [self logMessage:[NSString stringWithFormat:@"Camera %@ updated! Streaming state: %@",
                                                            camera.name, camera.isStreaming ? @"YES" : @"NO"]];
            }
        }];

        [self.deviceObserverHandles addObject:@(handle)];
    }
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

- (void)logMessage:(NSString *)message {
    self.nestInfoTextView.text = [self.nestInfoTextView.text stringByAppendingFormat:@"%@\n", message];
}

#pragma mark - NestSDKConnectWithNestButtonDelegate

- (void)connectWithNestButton:(NestSDKConnectWithNestButton *)connectWithNestButton
       didAuthorizeWithResult:(NestSDKAuthorizationManagerAuthorizationResult *)result error:(NSError *)error {

    if (error) {
        NSLog(@"Process error: %@", error);

    } else if (result.isCancelled) {
        NSLog(@"Cancelled");

    } else {
        NSLog(@"Authorized!");

        [self observeStructures];
    }
}

- (void)connectWithNestButtonDidUnauthorize:(NestSDKConnectWithNestButton *)connectWithNestButton {
    [self removeObservers];
}


@end
