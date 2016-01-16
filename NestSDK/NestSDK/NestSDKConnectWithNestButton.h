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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NestSDKAuthorizationManagerAuthorizationResult;
@class NestSDKConnectWithNestButton;

#pragma mark Protocol

/**

 A delegate for `NestSDKConnectWithNestButton`

 */
@protocol NestSDKConnectWithNestButtonDelegate <NSObject>
#pragma mark Methods

@required
/**

 Sent to the delegate when the button was used to login.

 @param loginButton the sender
 @param result The results of the login
 @param error The error (if any) from the login

 */
- (void)connectWithNestButton:(NestSDKConnectWithNestButton *)loginButton
        didCompleteWithResult:(NestSDKAuthorizationManagerAuthorizationResult *)result
                        error:(NSError *)error;

/**

 Sent to the delegate when the button was used to logout.
 @param loginButton The button that was clicked.

*/
- (void)loginButtonDidLogOut:(NestSDKConnectWithNestButton *)loginButton;

@optional
/**

 Sent to the delegate when the button is about to login.
 @param loginButton the sender
 @return YES if the login should be allowed to proceed, NO otherwise

 */
- (BOOL)loginButtonWillLogin:(NestSDKConnectWithNestButton *)loginButton;

@end


@interface NestSDKConnectWithNestButton : UIButton <UIActionSheetDelegate>
#pragma mark Properties

@property(weak, nonatomic) IBOutlet id <NestSDKConnectWithNestButtonDelegate> delegate;

@end