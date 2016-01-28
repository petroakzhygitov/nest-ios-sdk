#import <Foundation/Foundation.h>

@class NestSDKProductResourceDataModel;
@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKProductResourceUseDataModel <NSObject>

@end


/**
 * An object containing the resource use type (electricity, gas, water), with data values and measurement timestamps.
 */
@interface NestSDKProductResourceUseDataModel : JSONModel <NestSDKProductResourceUseDataModel>
#pragma mark Properties

/**
 * An object that contains electricity data for the product type.
 */
@property(nonatomic) NestSDKProductResourceDataModel <Optional> *electricity;

/**
 * An object that contains gas data for the product type.
 */
@property(nonatomic) NestSDKProductResourceDataModel <Optional> *gas;

/**
 * An object that contains water data for the product type.
 */
@property(nonatomic) NestSDKProductResourceDataModel <Optional> *water;

#pragma mark Methods

@end