#import <Firebase/Firebase.h>
#import "NestSDKStructuresManager.h"
#import "NestSDKStructure.h"

#pragma mark macros

#pragma mark const

static NSString *const kStructuresURLPath = @"structures/";

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

- (NestSDKObserverHandle)observeStructuresWithBlock:(NestSDKStructuresManagerStructuresUpdateBlock)block {
    if (!block) return NestSDKObserverHandleUndefined;

    [[NestSDKFirebaseManager sharedManager] addSubscriptionToURL:kStructuresURLPath withBlock:^(FDataSnapshot *snapshot) {
        NSMutableArray <NestSDKStructure> *structuresArray = (NSMutableArray <NestSDKStructure> *) [[NSMutableArray alloc] initWithCapacity:snapshot.childrenCount];

        for (FDataSnapshot *child in snapshot.children) {
            NSError *error;
            NestSDKStructure *structure = [[NestSDKStructure alloc] initWithDictionary:child.value error:&error];

            if (error) continue;

            [structuresArray addObject:structure];
        }

        block(structuresArray);
    }];

    return 0;
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end