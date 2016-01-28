#import <Foundation/Foundation.h>

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKProductSoftwareDataModel <NSObject>

@end


/**
 * An object containing the software version identifier for your product.
 */
@interface NestSDKProductSoftwareDataModel : JSONModel
#pragma mark Properties

/**
 * Software version number of your product or device.
 */
@property(nonatomic, copy) NSString <Optional> *version;

#pragma mark Methods

@end