#import <Foundation/Foundation.h>

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKProductIdentification

@end


@interface NestSDKProductIdentification : JSONModel
#pragma mark Properties

/**
 * Unique device identifier for your product, used in the Resource use API.
 * https://developer.nest.com/documentation/cloud/resource-use-guide
 */
@property(nonatomic, copy) NSString <Optional> *device_id;

/**
 * Serial number of your product or device, used in the Resource use API. Must be unique within your company and product type path.
 * https://developer.nest.com/documentation/cloud/resource-use-guide
 */
@property(nonatomic, copy) NSString <Optional> *serial_number;

#pragma mark Methods

@end