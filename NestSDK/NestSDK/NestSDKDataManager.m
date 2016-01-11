#import "NestSDKDataManager.h"
#import "JSONModel.h"
#import "NestSDKMetaData.h"
#import "NestSDKApplicationDelegate.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@interface NestSDKDataManager ()

@property(nonatomic) id <NestSDKService> service;

@end


@implementation NestSDKDataManager {
#pragma mark Instance variables
}

#pragma mark Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.service = [NestSDKApplicationDelegate service];
    }

    return self;
}

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

- (void)metadataWithBlock:(NestSDKMetadataUpdateHandler)block {
    [self.service valuesForURL:@"/" withBlock:^(id result, NSError *error) {
        if (error) {
            block(nil, error);
        }

        NestSDKMetaData *metadata = [[NestSDKMetaData alloc] initWithDictionary:result error:&error];

        block(metadata, error);
    }];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end