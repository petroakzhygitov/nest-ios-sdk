#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

/**
 * NestSDKApplicationDelegate is main connection point with Nest SDK.
 * It is designed to be able process the results from Nest authorization dialogs (native app or Safari) in the future.
 */
@interface NestSDKApplicationDelegate : NSObject
#pragma mark Properties

#pragma mark Methods

/**
 * Gets the singleton instance.
 */
+ (instancetype)sharedInstance;

/**
 * Call this method from the [UIApplicationDelegate application:openURL:sourceApplication:annotation:] method
 * of the AppDelegate for your app. It should be invoked for the proper processing of responses during interaction
 * with the native app or Safari as part of SSO authorization flow in the future.
 *
 * @param application The application as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 * @param url The URL as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 * @param sourceApplication The sourceApplication as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 * @param annotation The annotation as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 *
 * @return NO in any case for now.
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/**
 * Call this method from the [UIApplicationDelegate application:didFinishLaunchingWithOptions:] method
 * of the AppDelegate for your app. It should be invoked for the proper use of the Nest SDK in the future.
 *
 * @param application The application as passed to [UIApplicationDelegate application:didFinishLaunchingWithOptions:].
 * @param launchOptions The launchOptions as passed to [UIApplicationDelegate application:didFinishLaunchingWithOptions:].
 *
 * @return NO in any case for now.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end