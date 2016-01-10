#import <Foundation/Foundation.h>

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKMetaData <NSObject>

@end


@interface NestSDKMetaData : JSONModel <NestSDKMetaData>
#pragma mark Properties

@property(nonatomic, copy) NSString <Optional> *access_token;
@property(nonatomic) NSUInteger client_version;

#pragma mark Methods

@end