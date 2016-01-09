//
//  ViewController.h
//  NestSDKDemo
//
//  Created by Petro Akzhygitov on 7/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NestSDKConnectWithNestButtonDelegate, NestSDKConnectWithNestButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextView *nestInfoTextView;

@end

