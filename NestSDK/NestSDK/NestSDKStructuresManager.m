#import <Firebase/FDataSnapshot.h>
#import "NestSDKStructuresManager.h"
#import "NestSDKFirebaseManager.h"
#import "NestSDKStructure.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

@implementation NestSDKStructuresManager {
#pragma mark Instance variables
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

- (void)observeStructuresWithUpdateBlock:(NestSDKStructuresManagerStructuresUpdateBlock)block {
    if (!block) return;

    [[NestSDKFirebaseManager sharedManager] addSubscriptionToURL:@"structures/" withBlock:^(FDataSnapshot *snapshot) {
        NSMutableArray <NestSDKStructure> *structuresArray = (NSMutableArray <NestSDKStructure> *) [[NSMutableArray alloc] initWithCapacity:snapshot.childrenCount];

        for (FDataSnapshot *child in snapshot.children) {
            NSError *error;
            NestSDKStructure *structure = [[NestSDKStructure alloc] initWithDictionary:child.value error:&error];

            if (error) continue;

            [structuresArray addObject:structure];
        }

        block([structuresArray copy]);
    }];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end