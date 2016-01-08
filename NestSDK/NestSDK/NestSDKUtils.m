#import "NestSDKUtils.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation NestSDKUtils {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

+ (UIViewController *)viewControllerForView:(UIView *)view {
    UIResponder *responder = view.nextResponder;

    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) responder;
        }

        responder = responder.nextResponder;
    }

    return nil;
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end