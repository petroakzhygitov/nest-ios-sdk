//
//  AppDelegate.m
//  NestSDKDemoAdvanced
//
//  Created by Petro Akzhygitov on 14/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import "AppDelegate.h"
#import "NestSDKApplicationDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NestSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

@end
