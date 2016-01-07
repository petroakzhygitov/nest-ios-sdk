#import <Foundation/Foundation.h>

@protocol NestSDKStructure;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

typedef void (^NestSDKStructuresManagerStructuresUpdateBlock)(NSArray <NestSDKStructure> *structuresArray);

#pragma mark Protocol

@interface NestSDKStructuresManager : NSObject

#pragma mark Properties

#pragma mark Methods

- (void)observeStructuresWithUpdateBlock:(NestSDKStructuresManagerStructuresUpdateBlock)block;

@end