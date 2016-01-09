#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

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
@property(nonatomic, copy) NSString <Optional> *name;
@property(nonatomic, copy) NSString <Optional> *country_code;
@property(nonatomic, copy) NSString <Optional> *postal_code;
@property(nonatomic, copy) NSString <Optional> *time_zone;
//@property(nonatomic, copy) NSString <Optional> *wheres;

@property(nonatomic, copy) NSString <Optional> *away;

@property(nonatomic, copy) NSArray <Optional> *cameras;
@property(nonatomic, copy) NSArray <Optional> *smoke_co_alarms;
@property(nonatomic, copy) NSArray <Optional> *thermostats;

#pragma mark Methods

@end