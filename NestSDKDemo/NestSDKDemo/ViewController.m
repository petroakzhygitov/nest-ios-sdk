//
//  ViewController.m
//  NestSDKDemo
//
//  Created by Petro Akzhygitov on 7/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <NestSDK/NestSDKAuthorizationManager.h>
#import <NestSDK/NestSDKAuthorizationManagerAuthorizationResult.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Connect with Nest using NestSDKConnectWithNestButton
//    [self createConnectWithNestButton];

    // Connect with Nest using your custom button
    [self createCustomConnectWithNestButton];
}

- (void)createConnectWithNestButton {
//    NestSDKConnectWithNestButton *connectWithNestButton = [[NestSDKConnectWithNestButton alloc] init];
//    // Optional: Place the button in the center of your view.
//    connectWithNestButton.center = self.view.center;
//
//    [self.view addSubview:connectWithNestButton];
}

- (void)createCustomConnectWithNestButton {
    // Add a custom login button to your app
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

// Once the button is clicked, show the auth dialog
- (void)customConnectWithNestButtonClicked {
    NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];
    [authorizationManager authorizeWithNestAccountFromViewController:self
                                                             handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                 if (error) {
                                                                     NSLog(@"Process error: %@", error);
                                                                 } else if (result.isCancelled) {
                                                                     NSLog(@"Cancelled");
                                                                 } else {
                                                                     NSLog(@"Authorized!");
                                                                 }
                                                             }];
}

@end
