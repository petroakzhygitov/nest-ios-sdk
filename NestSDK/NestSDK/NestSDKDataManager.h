#import <Foundation/Foundation.h>
#import "NestSDKDevicesManager.h"
#import "NestSDKStructuresManager.h"

@class NestSDKMetaData;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

typedef void (^NestSDKMetadataUpdateHandler)(NestSDKMetaData *, NSError *);

#pragma mark Protocol

@interface NestSDKDataManager : NSObject
#pragma mark Properties

#pragma mark Methods

- (void)metadataWithBlock:(NestSDKMetadataUpdateHandler)block;


- (void)structuresWithBlock:(NestSDKStructuresManagerStructuresUpdateBlock)block;

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresManagerStructuresUpdateBlock)block;


- (void)thermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (void)setThermostat:(NestSDKThermostat *)thermostat block:(NestSDKThermostatUpdateHandler)block;


- (void)smokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKThermostatUpdateHandler)block;

- (void)setSmokeCOAlarm:(NestSDKSmokeCOAlarm *)smokeCOAlarm block:(NestSDKThermostatUpdateHandler)block;


- (void)cameraWithId:(NSString *)cameraId block:(NestSDKThermostatUpdateHandler)block;

- (void)setCamera:(NestSDKCamera *)camera block:(NestSDKThermostatUpdateHandler)block;


- (void)observeThermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (void)observeSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block;

- (void)observeCameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block;


- (void)removeObserverWithHandle:(NestSDKObserverHandle)handle;

- (void)removeAllObservers;


@end