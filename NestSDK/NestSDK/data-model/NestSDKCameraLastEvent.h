#import <Foundation/Foundation.h>
#import "JSONModel.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKCameraLastEvent

@end


@interface NestSDKCameraLastEvent : JSONModel
#pragma mark Properties

@property(nonatomic) BOOL has_sound;
@property(nonatomic) BOOL has_motion;

@property(nonatomic, copy) NSString <Optional> *start_time;
@property(nonatomic, copy) NSString <Optional> *end_time;

@property(nonatomic, copy) NSString <Optional> *web_url;
@property(nonatomic, copy) NSString <Optional> *app_url;
@property(nonatomic, copy) NSString <Optional> *image_url;
@property(nonatomic, copy) NSString <Optional> *animated_image_url;

#pragma mark Methods

@end