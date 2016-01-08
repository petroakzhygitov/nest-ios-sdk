#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NestSDKAuthorizationViewController.h"

@class NestSDKAuthorizationManagerAuthorizationResult;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

typedef void (^NestSDKAuthorizationManagerAuthorizationHandler)(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error);

#pragma mark Protocol

@interface NestSDKAuthorizationManager : NSObject <NestSDKAuthorizationViewControllerDelegate>
#pragma mark Properties

#pragma mark Methods

- (void)authorizeWithNestAccountFromViewController:(UIViewController *)viewController
                                           handler:(NestSDKAuthorizationManagerAuthorizationHandler)handler;

- (void)unauthorize;

@end