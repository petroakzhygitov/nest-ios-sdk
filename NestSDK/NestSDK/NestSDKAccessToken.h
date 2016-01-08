#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface NestSDKAccessToken : NSObject <NSSecureCoding>
#pragma mark Properties

@property(readonly, nonatomic) NSDate *expirationDate;
@property(readonly, copy, nonatomic) NSString *tokenString;

#pragma mark Methods

- (instancetype)initWithTokenString:(NSString *)tokenString expirationDate:(NSDate *)expirationDate NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToAccessToken:(NestSDKAccessToken *)token;

+ (NestSDKAccessToken *)currentAccessToken;

+ (void)setCurrentAccessToken:(NestSDKAccessToken *)token;


@end