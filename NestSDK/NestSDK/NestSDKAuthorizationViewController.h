#import <UIKit/UIKit.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKAuthorizationViewControllerDelegate <NSObject>

- (void)hasCancelledAuthorization;

- (void)hasReceivedAuthorizationCode:(NSString *)authorizationCode;

@end


@interface NestSDKAuthorizationViewController : UIViewController

#pragma mark Properties

@property(nonatomic, strong) id <NestSDKAuthorizationViewControllerDelegate> delegate;

@property(readonly, copy, nonatomic) NSURL *authorizationURL;
@property(readonly, copy, nonatomic) NSURL *redirectURL;

#pragma mark Methods

- (instancetype)initWithAuthorizationURL:(NSURL *)authorizationURL
                             redirectURL:(NSURL *)redirectURL
                                delegate:(id <NestSDKAuthorizationViewControllerDelegate>)delegate;

@end
