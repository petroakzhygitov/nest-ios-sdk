#import <Foundation/Foundation.h>

@class NestSDKThermostat;
@class NestSDKSmokeCOAlarm;
@class NestSDKCamera;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

typedef void (^NestSDKThermostatUpdateHandler)(NestSDKThermostat *, NSError *);

typedef void (^NestSDKSmokeCOAlarmUpdateHandler)(NestSDKSmokeCOAlarm *, NSError *);

typedef void (^NestSDKCameraUpdateHandler)(NestSDKCamera *, NSError *);

#pragma mark Protocol


@interface NestSDKDevicesManager : NSObject
#pragma mark Properties

#pragma mark Methods

- (void)observeThermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (void)observeSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block;

- (void)observeCameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block;

- (void)removeAllObservers;

@end