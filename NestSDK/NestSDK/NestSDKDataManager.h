#import <Foundation/Foundation.h>
#import "NestSDKService.h"

@class NestSDKMetadata;
@class NestSDKThermostat;
@class NestSDKSmokeCOAlarm;
@class NestSDKCamera;
@protocol NestSDKStructure;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

typedef void (^NestSDKStructuresUpdateHandler)(NSArray <NestSDKStructure> *structuresArray, NSError *);

typedef void (^NestSDKMetadataUpdateHandler)(NestSDKMetadata *, NSError *);

typedef void (^NestSDKThermostatUpdateHandler)(NestSDKThermostat *, NSError *);

typedef void (^NestSDKSmokeCOAlarmUpdateHandler)(NestSDKSmokeCOAlarm *, NSError *);

typedef void (^NestSDKCameraUpdateHandler)(NestSDKCamera *, NSError *);

#pragma mark Protocol

@interface NestSDKDataManager : NSObject
#pragma mark Properties

#pragma mark Methods

- (void)metadataWithBlock:(NestSDKMetadataUpdateHandler)block;


- (void)structuresWithBlock:(NestSDKStructuresUpdateHandler)block;

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresUpdateHandler)block;


- (void)thermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (void)setThermostat:(NestSDKThermostat *)thermostat block:(NestSDKThermostatUpdateHandler)block;


- (void)smokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKThermostatUpdateHandler)block;

- (void)setSmokeCOAlarm:(NestSDKSmokeCOAlarm *)smokeCOAlarm block:(NestSDKThermostatUpdateHandler)block;


- (void)cameraWithId:(NSString *)cameraId block:(NestSDKThermostatUpdateHandler)block;

- (void)setCamera:(NestSDKCamera *)camera block:(NestSDKThermostatUpdateHandler)block;


- (NestSDKObserverHandle)observeThermostatWithId:(NSString *)thermostatId block:(NestSDKThermostatUpdateHandler)block;

- (NestSDKObserverHandle)observeSmokeCOAlarmWithId:(NSString *)smokeCOAlarmId block:(NestSDKSmokeCOAlarmUpdateHandler)block;

- (NestSDKObserverHandle)observeCameraWithId:(NSString *)cameraId block:(NestSDKCameraUpdateHandler)block;


- (void)removeObserverWithHandle:(NestSDKObserverHandle)handle;

- (void)removeAllObservers;


@end