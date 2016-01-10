# NestSDK for iOS
<!--- 

[![CI Status](http://img.shields.io/travis/petroakzhygitov/NestSDK.svg?style=flat)](https://travis-ci.org/petroakzhygitov/NestSDK)
[![Version](https://img.shields.io/cocoapods/v/NestSDK.svg?style=flat)](http://cocoapods.org/pods/NestSDK)
[![License](https://img.shields.io/cocoapods/l/NestSDK.svg?style=flat)](http://cocoapods.org/pods/NestSDK)
[![Platform](https://img.shields.io/cocoapods/p/NestSDK.svg?style=flat)](http://cocoapods.org/pods/NestSDK) 

-->
This open-source library allows you to integrate Nest API into your iOS app.

Learn more about Nest API at https://developer.nest.com/documentation/cloud/get-started

## Example

To run the example project, clone the repo, and run `pod install` from the NestSDKDemo directory first.

## Installation

NestSDK is under development so it is not publicly available through [CocoaPods](http://cocoapods.org) yet. To install
it, simply add the following line to your Podfile:

```ruby
pod "NestSDK", github => "https://github.com/petroakzhygitov/nest-ios-sdk.git"
```

## Usage

### Connect with Nest

The Nest SDK for iOS enables people to connect your Nest product app with their's personal Nest account. 
When people connect their's personal Nest account with your Nest product app they grant permissions to your app so 
you can retrieve and modify information on their behalf.

**NB:** Connect with Nest **supports Web-based Authorization** only. **PIN-based Authorization** is **not supported**.

====================================
####Setup steps:

1. General Nest product Setup
2. General iOS Setup
3. Add Connect With Nest Button Code

#####*Optional:*

- Custom Connect With Nest Button

====================================
####1. General Nest product Setup

- Create your Nest developers account at [https://home.nest.com] (https://home.nest.com/login/?style=default&next=%2Faccounts%2Fsaml2%2Fidp%2Fcomplete%3FSAMLRequest%3DPHNhbWxwOkF1dGhuUmVxdWVzdCBBc3NlcnRpb25Db25zdW1lclNlcnZpY2VVUkw9J2h0dHBzOi8vZGV2ZWxvcGVyLm5lc3QuY29tL2F1dGgvc2FtbC9zZXNzaW9ucycgRGVzdGluYXRpb249J2h0dHBzOi8vaG9tZS5uZXN0LmNvbS9hY2NvdW50cy9zYW1sMi9pZHAvcG9zdD9zdHlsZT1kZWZhdWx0JyBJRD0nXzJjNzBjYjQwLTk5YmYtMDEzMy05NmM1LTIyMDAwYjIyMDZiMCcgSXNQYXNzaXZlPSdmYWxzZScgSXNzdWVJbnN0YW50PScyMDE2LTAxLTEwVDExOjU2OjU3WicgVmVyc2lvbj0nMi4wJyB4bWxuczpzYW1sPSd1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YXNzZXJ0aW9uJyB4bWxuczpzYW1scD0ndXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOnByb3RvY29sJz48c2FtbDpJc3N1ZXI%252BaHR0cHM6Ly9kZXZlbG9wZXIubmVzdC5jb208L3NhbWw6SXNzdWVyPjxzYW1scDpOYW1lSURQb2xpY3kgQWxsb3dDcmVhdGU9J3RydWUnIEZvcm1hdD0ncm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6cHJvdG9jb2wnLz48L3NhbWxwOkF1dGhuUmVxdWVzdD4%253D#/sign-up)

- Create your Nest Product at [https://developer.nest.com/products/new] (https://developer.nest.com/products/new)

- Indicate `Redirect URI`. Do not leave text field empty, since PIN-based Authorization is not supported.

- Use your product `Product ID`, `Product Secret` and `Redirect URI` for the iOS project setup.

====================================
####2. General iOS project Setup

- Add NestSDK to your project (see Installation)

- Configure the `.plist` for your project:

In Xcode right-click your `.plist` file and choose "Open As Source Code".
Copy & Paste the XML snippet into the body of your file (`<dict>...</dict>`).

```objective-c
	<key>NestProductID</key>
	<string>{your-product-id}</string>
	<key>NestProductSecret</key>
	<string>{your-product-secret}</string>
	<key>NestRedirectURL</key>
	<string>{your-product-redirect-url}</string>
```

Replace:
- `{your-product-id}` with your product `Product ID`.
- `{your-product-secret}` with your product `Product Secret`.
- `{your-product-redirect-url}` with your product `Redirect URI`.

- Connect Application Delegate

Conenct your `AppDelegate` to the `NestSDKApplicationDelegate`. In your `AppDelegate.m` add:

```objective-c
//  AppDelegate.m
#import <FBSDKCoreKit/FBSDKCoreKit.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[NestSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
  
  return YES;
}
```

====================================
####3. Add Connect With Nest Button Code

To add a `Connect with Nest` button to your app add the following code snippet to a view controller.

```objective-c
// Add this to the header of your file, e.g. in ViewController.m 
// after #import "ViewController.h"
#import <NestSDK/NestSDK.h>

// Add this to the body
@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NestSDKConnectWithNestButton *connectWithNestButton = [[NestSDKConnectWithNestButton alloc] init];
  
  // Optional: Place the button in the center of your view.
  connectWithNestButton.center = self.view.center;
  
  [self.view addSubview:connectWithNestButton];
}
    
@end
```

====================================
####Optional: Custom Connect With Nest Button

Instead of using the predefined `Connect with Nest` button (explained in 3. Add Connect With Nest Button Code) you may want to design a custom layout and behavior. In the following code example we invoke the authorization dialog using the authorization manager class (`NestSDKAuthorizationManager`) and a custom button (`UIButton`). You can use any other custom user interface or event handling to invoke the login dialog.

```objective-c
// Add this to the header of your file
#import "ViewController.h"
#import <NestSDK/NestSDK.h>

// Add this to the body
@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
  // Add a custom login button to your app
  UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
  myLoginButton.backgroundColor=[UIColor darkGrayColor];
  myLoginButton.frame=CGRectMake(0,0,180,40);
  myLoginButton.center = self.view.center;
  [myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];

  // Handle clicks on the button
  [myLoginButton 
    addTarget:self 
    action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
 
  // Add the button to the view
  [self.view addSubview:myLoginButton];
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login
    logInWithReadPermissions: @[@"public_profile"]
          fromViewController:self
                     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    if (error) { 
      NSLog(@"Process error");
    } else if (result.isCancelled) {
      NSLog(@"Cancelled");
    } else {
      NSLog(@"Logged in");
    }
  }];
}
    
@end
```

## Author

Petro Akzhygitov (petro.akzhygitov@gmail.com)

## License

NestSDK is available under the MIT license. See the LICENSE file for more info.
