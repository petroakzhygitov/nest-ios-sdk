#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "NestSDKDevice.h"

@class NestSDKCameraLastEvent;

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@protocol NestSDKCamera <NestSDKDevice>

@end

@interface NestSDKCamera : NestSDKDevice <NestSDKCamera>
#pragma mark Properties

@property(nonatomic) BOOL is_streaming;
@property(nonatomic) BOOL is_audio_input_enabled;

@property(nonatomic, copy) NSString <Optional> *last_is_online_change;

@property(nonatomic) BOOL is_video_history_enabled;

@property(nonatomic, copy) NSString <Optional> *web_url;
@property(nonatomic, copy) NSString <Optional> *app_url;

@property(nonatomic) NestSDKCameraLastEvent *last_event;

#pragma mark Methods

@end