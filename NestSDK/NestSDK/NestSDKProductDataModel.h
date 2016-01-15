#import <Foundation/Foundation.h>
#import "JSONModel.h"

@class NestSDKProductIdentification;
@class NestSDKProductLocation;
@class NestSDKProductSoftware;
@class NestSDKProductResourceUse;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKProductDataModel <NSObject>

@end

@interface NestSDKProductDataModel : JSONModel <NestSDKProductDataModel>
#pragma mark Properties

@property(nonatomic) NestSDKProductIdentification <Optional> *identification;
@property(nonatomic) NestSDKProductLocation <Optional> *location;
@property(nonatomic) NestSDKProductSoftware <Optional> *software;
@property(nonatomic) NestSDKProductResourceUse <Optional> *resource_use;

#pragma mark Methods

@end