#import "NestSDKThermostatsManager.h"
#import "NestSDKThermostat.h"
#import "FDataSnapshot.h"
#import "NestSDKFirebaseManager.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation NestSDKThermostatsManager {
#pragma mark Instance variables
}

#pragma mark Initializer

- (void)observeThermostatWithId:(NSString *)thermostatId updateBlock:(NestSDKThermostatsManagerThermostatUpdateBlock)block {
    if (!block) return;

    [[NestSDKFirebaseManager sharedManager] addSubscriptionToURL:[NSString stringWithFormat:@"devices/thermostats/%@/", thermostatId] withBlock:^(FDataSnapshot *snapshot) {
        NSError *error;
        NestSDKThermostat *thermostat = [[NestSDKThermostat alloc] initWithDictionary:snapshot.value error:&error];

        if (error) return;

        block(thermostat);
    }];
}

#pragma mark Private

- (void)removeAllObservers {

}

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end