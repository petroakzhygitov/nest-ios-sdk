#import <JSONModel/JSONModel.h>
#import "NestSDKWheres.h"


@implementation NestSDKWheres

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result = prime * result + self.name.hash;
    result = prime * result + self.whereId.hash;

    return result;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;

    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    NestSDKWheres *otherWheres = (NestSDKWheres *) other;
    return ((!self.name || [self.name isEqualToString:otherWheres.name]) &&
            (!self.whereId || [self.whereId isEqualToString:otherWheres.whereId]));
}


@end