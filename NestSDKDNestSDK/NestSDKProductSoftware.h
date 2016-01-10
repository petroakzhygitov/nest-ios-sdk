#import <Foundation/Foundation.h>

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKProductSoftware <NSObject>

@end


/**
 * An object containing the software version identifier for your product.
 */
@interface NestSDKProductSoftware : JSONModel
#pragma mark Properties

/**
 * Software version number of your product or device.
 */
@property(nonatomic, copy) NSString <Optional> *version;

#pragma mark Methods

@end