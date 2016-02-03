#import <Foundation/Foundation.h>


@interface CameraViewModel : NSObject
#pragma mark Properties

@property(nonatomic, copy) NSString *nameLongText;

@property(nonatomic, copy) NSString *connectionStatusText;

@property(nonatomic) BOOL streaming;

#pragma mark Methods

+ (instancetype)viewModelWithCamera:(id <NestSDKCamera>)camera;

@end