#import <Foundation/Foundation.h>
#import "NestSDKFirebaseManager.h"
#import "NestSDKService.h"
#import "NestSDKDataManager.h"

@protocol NestSDKStructure;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface NestSDKStructuresManager : NSObject

#pragma mark Properties

#pragma mark Methods

- (void)structuresWithBlock:(NestSDKStructuresUpdateHandler)block;
//- (void)setStructures:WithBlock:();

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresUpdateHandler)block;

- (void)removeObserverWithObserveHandle:(NestSDKObserverHandle)handle;

- (void)removeAllObservers;

@end