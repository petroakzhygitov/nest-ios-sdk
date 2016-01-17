// Copyright (c) 2016 Petro Akzhygitov <petro.akzhygitov@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@class NestSDKAuthorizationViewController;

#pragma mark Protocol

@protocol NestSDKAuthorizationViewControllerDelegate <NSObject>

- (void)viewControllerDidCancel:(NestSDKAuthorizationViewController *)viewController;

- (void)viewController:(NestSDKAuthorizationViewController *)viewController didReceiveAuthorizationCode:(NSString *)authorizationCode;

- (void)viewController:(NestSDKAuthorizationViewController *)viewController didFailWithError:(NSError *)error;

@end

/**
 * View controller that handles Nest authorization.
 */
@interface NestSDKAuthorizationViewController : UIViewController
#pragma mark Properties

/**
 *
 */
@property(nonatomic) id <NestSDKAuthorizationViewControllerDelegate> delegate;

/**
 * Authorization endpoint URL.
 */
@property(readonly, copy, nonatomic) NSURL *authorizationURL;

/**
 * Redirect URL.
 */
@property(readonly, copy, nonatomic) NSURL *redirectURL;

#pragma mark Methods

/**
 * Unavailable. Use `initWithAuthorizationURL:redirectURL:delegate` instead.
 */
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAuthorizationURL:(NSURL *)authorizationURL
                             redirectURL:(NSURL *)redirectURL
                                delegate:(id <NestSDKAuthorizationViewControllerDelegate>)delegate;

@end
