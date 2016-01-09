#import "NestSDKDevicesManager.h"
#import "NestSDKThermostat.h"
#import "NestSDKCamera.h"
#import "NestSDKSmokeCOAlarm.h"
#import "NestSDKFirebaseManager.h"

#pragma mark macros

#pragma mark const

static NSString *const kEndpointPathDevices = @"devices/";
static NSString *const kEndpointPathThermostats = @"thermostats/";
static NSString *const kEndpointPathSmokeCOAlarms = @"smoke_co_alarms/";
static NSString *const kEndpointPathCameras = @"cameras/";

#pragma mark enum

typedef NS_ENUM(NSUInteger, NestSDKDeviceType) {
    NestSDKDeviceTypeUndefined = 0,
    NestSDKDeviceTypeThermostat,
    NestSDKDeviceTypeSmokeCOAlarm,
    NestSDKDeviceTypeCamera
};

#pragma mark typedef

typedef void (^NestSDKDeviceUpdateHandler)(id, NSError *);


@implementation NestSDKDevicesManager {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

- (void)_addSubscriptionToDeviceWithType:(NestSDKDeviceType)deviceType deviceId:(NSString *)deviceId block:(NestSDKDeviceUpdateHandler)block {
    if (!block) return;

    if (deviceId.length == 0) {
        block(nil, [self _missingArgumentsError]);

        return;
    }

    NSString *subscriptionURLString = [self _subscriptionURLStringWithDeviceType:deviceType deviceId:deviceId];

    [[NestSDKFirebaseManager sharedManager] addSubscriptionToURL:subscriptionURLString withBlock:^(FDataSnapshot *snapshot) {
        id objectDictionary = snapshot.value;

        // We are expecting dictionary from Firebase
        if (![objectDictionary isKindOfClass:[NSDictionary class]]) return;

        NSError *error;
        id deviceObject = [self _deviceObjectWithDictionary:objectDictionary type:deviceType error:&error];

        block(deviceObject, error);
    }];
}

- (id)_deviceObjectWithDictionary:(NSDictionary *)dictionary type:(NestSDKDeviceType)deviceType error:(NSError **)error {
    id deviceObject;

    switch (deviceType) {
        case NestSDKDeviceTypeThermostat:
            deviceObject = [[NestSDKThermostat alloc] initWithDictionary:dictionary error:error];

            break;
        case NestSDKDeviceTypeSmokeCOAlarm:
            deviceObject = [[NestSDKSmokeCOAlarm alloc] initWithDictionary:dictionary error:error];

            break;
        case NestSDKDeviceTypeCamera:
            deviceObject = [[NestSDKCamera alloc] initWithDictionary:dictionary error:error];

            break;
        case NestSDKDeviceTypeUndefined:
            deviceObject = nil;

            break;
    }

    return deviceObject;
}

- (NSString *)_subscriptionURLStringWithDeviceType:(NestSDKDeviceType)deviceType deviceId:(NSString *)deviceId {
    NSString *subscriptionURLString;

    switch (deviceType) {
        case NestSDKDeviceTypeThermostat:
            subscriptionURLString = [self _subscriptionURLStringWithThermostatId:deviceId];

            break;
        case NestSDKDeviceTypeSmokeCOAlarm:
            subscriptionURLString = [self _subscriptionURLStringWithSmokeCOAlarmId:deviceId];

            break;
        case NestSDKDeviceTypeCamera:
            subscriptionURLString = [self _subscriptionURLStringWithCameraId:deviceId];

            break;
        case NestSDKDeviceTypeUndefined:
            subscriptionURLString = nil;

            break;
    }

    return subscriptionURLString;
}

- (NSString *)_subscriptionURLStringWithThermostatId:(NSString *)thermostatId {
    return [NSString stringWithFormat:@"%@%@%@/", kEndpointPathDevices, kEndpointPathThermostats, thermostatId];
}

- (NSString *)_subscriptionURLStringWithSmokeCOAlarmId:(NSString *)smokeCOAlarmId {
    return [NSString stringWithFormat:@"%@%@%@/", kEndpointPathDevices, kEndpointPathSmokeCOAlarms, smokeCOAlarmId];
}

- (NSString *)_subscriptionURLStringWithCameraId:(NSString *)cameraId {
    return [NSString stringWithFormat:@"%@%@%@/", kEndpointPathDevices, kEndpointPathCameras, cameraId];
}

- (NSError *)_missingArgumentsError {
    return nil;
}

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

- (void)observeThermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block {
    [self _addSubscriptionToDeviceWithType:NestSDKDeviceTypeThermostat deviceId:thermostatId block:block];
}

- (void)observeSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block {
    [self _addSubscriptionToDeviceWithType:NestSDKDeviceTypeSmokeCOAlarm deviceId:smokeCOAlarmId block:block];
}

- (void)observeCameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block {
    [self _addSubscriptionToDeviceWithType:NestSDKDeviceTypeCamera deviceId:cameraId block:block];
}

- (void)removeAllObservers {

}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end