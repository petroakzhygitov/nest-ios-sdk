#import <Foundation/Foundation.h>

@class NestSDKThermostat;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

typedef void (^NestSDKThermostatsManagerThermostatUpdateBlock)(NestSDKThermostat *thermostat);

#pragma mark Protocol

@interface NestSDKThermostatsManager : NSObject
#pragma mark Properties

#pragma mark Methods

- (void)observeThermostatWithId:(NSString *)string updateBlock:(NestSDKThermostatsManagerThermostatUpdateBlock)block;

- (void)removeAllObservers;

@end