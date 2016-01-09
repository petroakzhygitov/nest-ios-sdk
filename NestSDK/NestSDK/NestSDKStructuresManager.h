#import <Foundation/Foundation.h>
#import "NestSDKFirebaseManager.h"

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

- (void)structuresWithBlock:(NestSDKStructuresManagerStructuresUpdateBlock)block;
//- (void)setStructures:WithBlock:();

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresManagerStructuresUpdateBlock)block;
- (void)removeObserverWithObserveHandle:(NestSDKObserverHandle)handle;

- (void)removeAllObservers;

@end