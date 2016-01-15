#import <Foundation/Foundation.h>
#import "NestSDKDeviceProtocol.h"

@protocol NestSDKCameraLastEventProtocol;

/**
 * Camera device data model.
 */
@protocol NestSDKCameraProtocol <NestSDKDeviceProtocol>
#pragma mark Properties

/**
 * Camera status, either on and actively streaming video, or off.
 *
 * Learn how to set Nest Cam streaming based on Away mode: https://nest.com/ie/support/article/Can-I-have-my-Nest-Cam-turn-on-automatically-when-my-Nest-Thermostat-goes-into-Away-mode
 */
@property(nonatomic) BOOL isStreaming;
/**
 * Camera microphone status, either on and listening, or off.
 *
 * Learn more about Nest Cam audio setting: https://nest.com/support/article/Does-Nest-Cam-have-audio
 */
@property(nonatomic) BOOL isAudioInputEnabled;

/**
 * Timestamp that identifies the last change to the online status.
 */
@property(nonatomic) NSDate *lastIsOnlineChange;

/**
 * Nest Aware with Video History subscription status (subscription active or not).
 *
 * Learn more about Nest Aware with Video History: https://nest.com/support/article/What-do-I-get-with-Nest-Aware-for-Nest-Cam
 */
@property(nonatomic) BOOL isVideoHistoryEnabled;

/**
 * Web URL (deep link) to the live camera feed at home.nest.com.
 */
@property(nonatomic, copy) NSString *webUrl;

/**
 * App URL (deep link) to the live camera feed in the Nest app.
 */
@property(nonatomic, copy) NSString *appUrl;

/**
 * This object captures information about the last event that triggered a notification.
 * In order to capture last event data, the Nest Cam must have a Nest Aware with Video History subscription.
 */
@property(nonatomic) id <NestSDKCameraLastEventProtocol> lastEvent;


@end