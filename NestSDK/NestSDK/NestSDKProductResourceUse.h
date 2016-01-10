#import <Foundation/Foundation.h>

@class NestSDKProductResource;
@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKProductResourceUse <NSObject>

@end


/**
 * An object containing the resource use type (electricity, gas, water), with data values and measurement timestamps.
 */
@interface NestSDKProductResourceUse : JSONModel <NestSDKProductResourceUse>
#pragma mark Properties

/**
 * An object that contains electricity data for the product type.
 */
@property(nonatomic) NestSDKProductResource <Optional> *electricity;

/**
 * An object that contains gas data for the product type.
 */
@property(nonatomic) NestSDKProductResource <Optional> *gas;

/**
 * An object that contains water data for the product type.
 */
@property(nonatomic) NestSDKProductResource <Optional> *water;

#pragma mark Methods

@end