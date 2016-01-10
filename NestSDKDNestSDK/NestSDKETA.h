#import <Foundation/Foundation.h>

@protocol Optional;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKETA <NSObject>

@end


@interface NestSDKETA : JSONModel <NestSDKETA>
#pragma mark Properties

/**
 * A unique, client-generated identifier to organize a stream of eta estimates
 */
@property(nonatomic, copy) NSString <Optional> *trip_id;

/**
 * The timestamp of the earliest time you expect the user to arrive, in ISO 8601 format
 */
@property(nonatomic, copy) NSString <Optional> *estimated_arrival_window_begin;

/**
 * The timestamp of the latest time you expect the user to arrive, in ISO 8601 format
 */
@property(nonatomic, copy) NSString <Optional> *estimated_arrival_window_end;

#pragma mark Methods

@end