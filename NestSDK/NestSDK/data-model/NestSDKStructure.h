#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@class NestSDKETA;
@class NestSDKWheres;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKStructure <NSObject>

@end

@interface NestSDKStructure : JSONModel <NestSDKStructure>
#pragma mark Properties

@property(nonatomic, copy) NSString <Optional> *structure_id;

@property(nonatomic, copy) NSArray <Optional> *thermostats;
@property(nonatomic, copy) NSArray <Optional> *smoke_co_alarms;
@property(nonatomic, copy) NSArray <Optional> *cameras;
@property(nonatomic, copy) NSArray <Optional> *devices;

@property(nonatomic, copy) NSString <Optional> *away;
@property(nonatomic, copy) NSString <Optional> *name;
@property(nonatomic, copy) NSString <Optional> *country_code;
@property(nonatomic, copy) NSString <Optional> *postal_code;

@property(nonatomic, copy) NSString <Optional> *peak_period_start_time;
@property(nonatomic, copy) NSString <Optional> *peak_period_end_time;

@property(nonatomic) NestSDKETA *eta;

/**
 * Rush Hour Rewards enrollment status.
 * http://support.nest.com/article/What-is-Rush-Hour-Rewards
 */
@property(nonatomic) BOOL rhr_enrollment;

/**
 * An object containing where identifiers (where_id and name) for devices in the structure.
 */
@property(nonatomic) NestSDKWheres *wheres;

#pragma mark Methods

@end