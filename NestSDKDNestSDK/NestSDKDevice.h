#import <Foundation/Foundation.h>
#import "JSONModel.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKDevice

@end


@interface NestSDKDevice : JSONModel <NestSDKDevice>
#pragma mark Properties

@property(nonatomic, copy) NSString <Optional> *device_id;
@property(nonatomic, copy) NSString <Optional> *locale;
@property(nonatomic, copy) NSString <Optional> *software_version;
@property(nonatomic, copy) NSString <Optional> *structure_id;
@property(nonatomic, copy) NSString <Optional> *name;
@property(nonatomic, copy) NSString <Optional> *name_long;
@property(nonatomic, copy) NSString <Optional> *last_connection;

@property(nonatomic) BOOL is_online;

@property(nonatomic, copy) NSString <Optional> *where_id;

#pragma mark Methods

@end