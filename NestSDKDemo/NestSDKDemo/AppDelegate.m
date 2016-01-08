//
//  AppDelegate.m
//  NestSDKDemo
//
//  Created by Petro Akzhygitov on 7/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <NestSDK/NestSDKAuthorizationManager.h>
#import <NestSDK/NestSDKApplicationDelegate.h>
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Connect NestSDK
    [[NestSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}


@end
