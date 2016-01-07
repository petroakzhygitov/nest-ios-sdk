#import "NestSDKAccessToken.h"
#import "NestSDKAccessTokenCache.h"

#pragma mark macros

#pragma mark const

static NSString *const kExpirationDateKey = @"expirationDateKey";
static NSString *const kTokenStringKey = @"tokenStringKey";

#pragma mark enum

#pragma mark typedef

static NestSDKAccessToken *g_currentAccessToken;


@implementation NestSDKAccessToken {
#pragma mark Instance variables
}

- (instancetype)init {
    return [self initWithTokenString:nil expirationDate:nil];
}

- (instancetype)initWithTokenString:(NSString *)tokenString expirationDate:(NSDate *)expirationDate {
    self = [super init];
    if (self) {
        _tokenString = [tokenString copy];
        _expirationDate = expirationDate;
    }

    return self;
}

#pragma mark Initializer

#pragma mark Private

#pragma mark Notification selectors

#pragma mark Override

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result = prime * result + self.tokenString.hash;
    result = prime * result + self.expirationDate.hash;

    return result;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[NestSDKAccessToken class]]) {
        return NO;
    }
    return [self isEqualToAccessToken:(NestSDKAccessToken *) object];
}

#pragma mark Public

- (BOOL)isEqualToAccessToken:(NestSDKAccessToken *)token {
    return (token &&
            [self.tokenString isEqualToString:token.tokenString] &&
            [self.expirationDate isEqualToDate:token.expirationDate]);
}

+ (NestSDKAccessToken *)currentAccessToken {
    return g_currentAccessToken;
}

+ (void)setCurrentAccessToken:(NestSDKAccessToken *)token {
    g_currentAccessToken = token;

    [[[NestSDKAccessTokenCache alloc] init] cacheAccessToken:token];
}

#pragma mark IBAction

#pragma mark Protocol NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark Protocol NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder {
    NSString *tokenString = [decoder decodeObjectOfClass:[NSString class] forKey:kTokenStringKey];
    NSDate *expirationDate = [decoder decodeObjectOfClass:[NSDate class] forKey:kExpirationDateKey];

    return [self initWithTokenString:tokenString expirationDate:expirationDate];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.tokenString forKey:kTokenStringKey];
    [encoder encodeObject:self.expirationDate forKey:kExpirationDateKey];
}

#pragma mark Delegate @delegate-name


@end