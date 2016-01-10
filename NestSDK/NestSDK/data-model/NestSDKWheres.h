#import <Foundation/Foundation.h>

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface NestSDKWheres : NSObject
#pragma mark Properties

/**
 *
 * A unique, Nest-generated identifier that represents name
 * Use this value with the /$company/ object to send resource use
 * where_id is read-only, and is created automatically in the call to create a custom where name
 *
 */
@property(nonatomic, copy) NSString <Optional> *where_id;

/**
 *
 * The display name of the device
 * To create a custom where name, make a POST call to write a new, custom where name; the where_id is returned in the call
 *
 * Considerations
 *      name cannot be edited or deleted after creation
 *      name must be unique within the structure
 *      If a device is paired to a structure, the custom where name associated with the device is accessible from the /structures/ path
 *      To move a device with a custom where name to a different structure, unpair the device, then re-pair the device with the desired name
 *
 */
@property(nonatomic, copy) NSString <Optional> *name;

#pragma mark Methods

@end