#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <NestSDK/NestSDKDataModel.h>

@protocol Optional;

@protocol NestSDKWheres <NSObject>

@end


@interface NestSDKWheres : NestSDKDataModel
#pragma mark Properties

/**
 *
 * A unique, Nest-generated identifier that represents name
 * Use this value with the /$company/ object to send resource use
 * whereId is read-only, and is created automatically in the call to create a custom where name
 *
 */
@property(nonatomic, copy) NSString <Optional> *whereId;

/**
 *
 * The display name of the device
 * To create a custom where name, make a POST call to write a new, custom where name; the whereId is returned in the call
 *
 * Considerations
 *      name cannot be edited or deleted after creation
 *      name must be unique within the structure
 *      If a device is paired to a structure, the custom where name associated with the device is accessible from the /structures/ path
 *      To move a device with a custom where name to a different structure, unpair the device, then re-pair the device with the desired name
 *
 */
@property(nonatomic, copy) NSString <Optional> *name;

@end