//
//  DevicesViewController.h
//  NestSDKDemoAdvanced
//
//  Created by Petro Akzhygitov on 14/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NestSDKDataManager;
@class NestSDKConnectWithNestButton;

@interface DevicesViewController : UIViewController <NestSDKConnectWithNestButtonDelegate, UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UIView *faderView;
@property(weak, nonatomic) IBOutlet UIView *connectWithNestView;

@property(weak, nonatomic) IBOutlet NestSDKConnectWithNestButton *connectWithNestButton;

@end