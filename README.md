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

## General Nest product setup

1. Create your Nest developers account at [https://home.nest.com] (https://home.nest.com/login/?style=default&next=%2Faccounts%2Fsaml2%2Fidp%2Fcomplete%3FSAMLRequest%3DPHNhbWxwOkF1dGhuUmVxdWVzdCBBc3NlcnRpb25Db25zdW1lclNlcnZpY2VVUkw9J2h0dHBzOi8vZGV2ZWxvcGVyLm5lc3QuY29tL2F1dGgvc2FtbC9zZXNzaW9ucycgRGVzdGluYXRpb249J2h0dHBzOi8vaG9tZS5uZXN0LmNvbS9hY2NvdW50cy9zYW1sMi9pZHAvcG9zdD9zdHlsZT1kZWZhdWx0JyBJRD0nXzJjNzBjYjQwLTk5YmYtMDEzMy05NmM1LTIyMDAwYjIyMDZiMCcgSXNQYXNzaXZlPSdmYWxzZScgSXNzdWVJbnN0YW50PScyMDE2LTAxLTEwVDExOjU2OjU3WicgVmVyc2lvbj0nMi4wJyB4bWxuczpzYW1sPSd1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YXNzZXJ0aW9uJyB4bWxuczpzYW1scD0ndXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOnByb3RvY29sJz48c2FtbDpJc3N1ZXI%252BaHR0cHM6Ly9kZXZlbG9wZXIubmVzdC5jb208L3NhbWw6SXNzdWVyPjxzYW1scDpOYW1lSURQb2xpY3kgQWxsb3dDcmVhdGU9J3RydWUnIEZvcm1hdD0ncm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6cHJvdG9jb2wnLz48L3NhbWxwOkF1dGhuUmVxdWVzdD4%253D#/sign-up)

2. Create your Nest Product at [https://developer.nest.com/products/new] (https://developer.nest.com/products/new)

3. Indicate `Redirect URI`. Do not leave text field empty, since PIN-based Authorization is not supported.

4. Use your product `Product ID`, `Product Secret` and `Redirect URI` for the iOS project setup.

## General iOS project setup

1. Add NestSDK to your project (see Installation)

2. Configure the `.plist` for your project:

  In Xcode right-click your `.plist` file and choose "Open As Source Code".
  Copy & Paste the XML snippet into the body of your file (`<dict>...</dict>`).

  ```
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

3. Connect Application Delegate

  Conenct your `AppDelegate` to the `NestSDKApplicationDelegate`. In your `AppDelegate.m` add:

  ```objective-c
  //  AppDelegate.m
  #import <FBSDKCoreKit/FBSDKCoreKit.h>

  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	  [[NestSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
  
	  return YES;
  }
  ```

## General iOS application workflow

Before reading, observing or writing any data to Nest devices or structures you should implement user authorization. So, the general application workflow should be following:

1. Authorize user with Nest using predefined `Connect with Nest` button (`NestSDKConnectWithNestButton`) or by manually handling authorization dialog with authorization manager class (`NestSDKAuthorizationManager`).

2. Read/Observe/Write devices, structures or meta data.

## Connect with Nest

The Nest SDK for iOS enables people to connect your Nest product app with their's personal Nest account. 
When people connect their's personal Nest account with your Nest product app they grant permissions to your app so 
you can retrieve and modify information on their behalf.

**NB:** Connect with Nest **supports Web-based Authorization** only. **PIN-based Authorization** is **not supported**.

[More information](https://developer.nest.com/documentation/cloud/authorization-overview) about Nest authorization.

### Add Connect with Nest button code

To add a `Connect with Nest` button to your app add the following code snippet to a view controller:

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

To get known whether user is already authorized check result of `[NestSDKAccessToken currentToken]` before starting authorization process:

```objective-c

if ([NestSDKAccessToken currentToken]) {
	NSLog(@"Authorized!");
  
} else {
	NSLog(@"Not authorized!);
}

```

### Custom Connect with Nest button

Instead of using the predefined `Connect with Nest` button (explained in Add Connect With Nest Button Code) you may want to design a custom layout and behavior. In the following code example we invoke the authorization dialog using the authorization manager class (`NestSDKAuthorizationManager`) and a custom button (`UIButton`). You can use any other custom user interface or event handling to invoke the authorization dialog.

```objective-c
// Add this to the header of your file
#import "ViewController.h"
#import <NestSDK/NestSDK.h>

// Add this to the body
@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
	// Add a custom connect with button to your app
	UIButton *customConnectWithNestButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customConnectWithNestButton.backgroundColor = [UIColor darkGrayColor];
	customConnectWithNestButton.frame = CGRectMake(0, 0, 240, 40);

	// Optional: Place the button in the center of your view.
	customConnectWithNestButton.center = self.view.center;
	[customConnectWithNestButton setTitle:@"Custom Connect Button" forState:UIControlStateNormal];

	// Handle clicks on the button
	[customConnectWithNestButton addTarget:self action:@selector(customConnectWithNestButtonClicked)
			              forControlEvents:UIControlEventTouchUpInside];

	// Add the button to the view
	[self.view addSubview:customConnectWithNestButton];
}

// Once the button is clicked, show the auth dialog
- (void)customConnectWithNestButtonClicked {
	NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];
	[authorizationManager authorizeWithNestAccountFromViewController:self
                                                             	 handler:^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
                                                                     if (error) {
							         	                                 NSLog(@"Process error: %@", error);
								
								                                     } else if (result.isCancelled) {
								                                         NSLog(@"Cancelled");
								
								                                     } else {
								                                         NSLog(@"Authorized!");
								                                     }
                                                                 }];
}
    
@end
```

## Structures

All Nest devices belong to a structure. A structure can have many devices. 

It's possible that a user has more than one structure attached to their Nest Account, so your product should offer a means for the user to choose from the available structures (a structure picker).

[More information](https://developer.nest.com/documentation/cloud/structure-guide) about Nest structures.

### Observing structures

To observe structures use `NestSDKDataManager`:
```objective-c
NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
[dataManager observeStructuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
	if (error) {
		NSLog(@"Error occurred while observing structures: %@", error);
		return;
	}
	
	for (NestSDKStructure *structure in structuresArray) {
		NSLog(@"Updated structure with name: %@", structure.name);
	}
}];
```

### Reading structures

In general it is better to observe structures rather than read them, since you will be updated with any changes happen. 

In case you want simply read structures use `NestSDKDataManager`:
```objective-c
NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
[dataManager structuresWithBlock:^(NSArray <NestSDKStructure> *structuresArray, NSError *error) {
	if (error) {
		NSLog(@"Error occurred while reading structures: %@", error);
		return;
	}
	
	for (NestSDKStructure *structure in structuresArray) {
		NSLog(@"Updated structure with name: %@", structure.name);
	}
}];
```

### Updating structures

It is possible to update structure's `away` status and set `eta`. To update a structure use `NestSDKDataManager`:
```objective-c
NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];
[dataManager setStructure:structure block:^(id <NestSDKStructure> structure, NSError *) {
	if (error) {
		NSLog(@"Error occurred while observing structure: %@", error);
		return;
	}
	
	NSLog(@"Updated structure with name: %@", structure.name);
}];
```


## Devices

There are three types of Nest devices available to read/observe/write:
- Thermostat ([more information](https://developer.nest.com/documentation/cloud/thermostat-guide))
- Smoke+CO Alarm ([more information](https://developer.nest.com/documentation/cloud/smoke-co-guide))
- Camera ([more information](https://developer.nest.com/documentation/cloud/camera-guide))

**NB:** Ensure, you have set proper permissions to read specific device data with your [Nest Product](https://developer.nest.com/products).

## Observing devices

To observe devices use `NestSDKDataManager`:
```objective-c
NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

NSString *thermostatId = structure.thermostats[someIndex];
[self.dataManager observeThermostatWithId:thermostatId block:^(id <NestSDKThermostat> thermostat, NSError *error) {
	if (error) {
		NSLog(@"Error occurred while observing thermostat: %@", error);
		return;
	}
	
	NSLog(@"Updated thermostat with name: %@", thermostat.name);
}];

NSString *smokeCOAlarmId = structure.smoke_co_alarms[someIndex];
[self.dataManager observeSmokeCOAlarmWithId:smokeCOAlarmId block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
    	if (error) {
		NSLog(@"Error occurred while observing smoke CO alarm: %@", error);
		return;
	}
	
	NSLog(@"Updated smoke+CO Alarm with name: %@", smokeCOAlarm.name);
}];
 
NSString *cameraId = structure.cameras[someIndex];
[self.dataManager observeCameraWithId:cameraId block:^(id <NestSDKCamera> camera, NSError *error) {
	if (error) {
		NSLog(@"Error occurred while observing camera: %@", error);
		return;
	}
	
	NSLog(@"Updated camera with name: %@", camera.name);
}];
```

## Reading devices

In general it is better to observe devices rather than read them, since you will be updated with any changes happen. 

In case you want simply read devices use `NestSDKDataManager`:
```objective-c
NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

NSString *thermostatId = structure.thermostats[someIndex];
[self.dataManager thermostatWithId:thermostatId block:^(id <NestSDKThermostat> thermostat, NSError *error) {
	if (error) {
		NSLog(@"Error occurred while observing thermostat: %@", error);
		return;
	}
	
	NSLog(@"Updated thermostat with name: %@", thermostat.name);
}];

NSString *smokeCOAlarmId = structure.smoke_co_alarms[someIndex];
[self.dataManager smokeCOAlarmWithId:smokeCOAlarmId block:^(id <NestSDKSmokeCOAlarm> smokeCOAlarm, NSError *error) {
    	if (error) {
		NSLog(@"Error occurred while observing smoke CO alarm: %@", error);
		return;
	}
	
	NSLog(@"Updated smoke+CO Alarm with name: %@", smokeCOAlarm.name);
}];
 
NSString *cameraId = structure.cameras[someIndex];
[self.dataManager cameraWithId:cameraId block:^(id <NestSDKCamera> camera, NSError *error) {
	if (error) {
		NSLog(@"Error occurred while observing camera: %@", error);
		return;
	}
	
	NSLog(@"Updated camera with name: %@", camera.name);
}];
```

### Updating devices

- It is possible to update thermostat's `fanTimerActive`, `fanTimerTimeout`, `targetTemperatureF`, `targetTemperatureC`, `targetTemperatureHighF`, `targetTemperatureHighC`, `targetTemperatureLowF`, `targetTemperatureLowC` and `hvacMode` values.
- It is possible to update camera's `isStreaming` status.
- It is **not possible** to update satuses/values for **smoke+CO alarm** device.

To update devices use `NestSDKDataManager`:
```objective-c
NestSDKDataManager *dataManager = [[NestSDKDataManager alloc] init];

[self.dataManager setThermostat:thermostat block:^(id <NestSDKThermostat> thermostat, NSError *error) {
	if (error) {
		NSLog(@"Error occurred while observing thermostat: %@", error);
		return;
	}
	
	NSLog(@"Updated thermostat with name: %@", thermostat.name);
}];

[self.dataManager setCamera:camera block:^(id <NestSDKCamera> camera, NSError *error) {
	if (error) {
		NSLog(@"Error occurred while observing camera: %@", error);
		return;
	}
	
	NSLog(@"Updated camera with name: %@", camera.name);
}];
```


## Author

Petro Akzhygitov (petro.akzhygitov@gmail.com)

## License

NestSDK is available under the MIT license. See the LICENSE file for more info.
