#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NestSDKAuthorizationManagerAuthorizationResult;
@class NestSDKConnectWithNestButton;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

/**

 A delegate for `NestSDKConnectWithNestButton`

 */
@protocol NestSDKConnectWithNestButtonDelegate <NSObject>

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

#pragma mark Methods

@end