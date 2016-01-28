#import <Foundation/Foundation.h>

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKProductLocationDataModel <NSObject>

@end


@interface NestSDKProductLocationDataModel : JSONModel <NestSDKProductLocationDataModel>
#pragma mark Properties

/**
 * Structure unique identifier, used in the Resource use API.
 */
@property(nonatomic, copy) NSString <Optional> *structure_id;

/**
 * whereId is a unique, Nest-generated identifier that represents name, the display name of the device. Learn more about where names for Nest Thermostats, Nest Protects and Nest Cams.
 */
@property(nonatomic, copy) NSString <Optional> *where_id;

#pragma mark Methods

@end