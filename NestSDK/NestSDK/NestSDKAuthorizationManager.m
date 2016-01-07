#import <libkern/OSAtomic.h>
#import "NestSDKAuthorizationManager.h"
#import "NestSDKAuthorizationManagerAuthorizationResult.h"
#import "NestSDKAccessToken.h"

#pragma mark macros

#pragma mark const

static NSString *const kNestClientIDKey = @"NestClientID";
static NSString *const kNestClientSecretKey = @"NestClientSecret";
static NSString *const kNestCurrentAPIDomainKey = @"NestCurrentAPIDomain";
static NSString *const kNestStateKey = @"NestState";
static NSString *const kNestRedirectURLKey = @"NestRedirectURL";

static NSString *const kNestAuthorizationURLFormat = @"https://%@/login/oauth2?client_id=%@&state=%@";
static NSString *const kNestAccessTokenURLFormat = @"https://api.%@/oauth2/access_token?code=%@&client_id=%@&client_secret=%@&grant_type=authorization_code";

#pragma mark enum

#pragma mark typedef


@implementation NestSDKAuthorizationManager {
#pragma mark Instance variables
    NestSDKAuthorizationViewController *_authorizationViewController;
    NestSDKAuthorizationManagerAuthorizationHandler _handler;

    int _authorizing;
}

#pragma mark Initializer

#pragma mark Private

- (NSString *)p_clientID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kNestClientIDKey];
}

- (NSString *)p_clientSecret {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kNestClientSecretKey];
}

- (NSString *)p_currentAPIDomain {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kNestCurrentAPIDomainKey];
}

- (NSString *)p_state {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kNestStateKey];
}

- (NSURL *)p_redirectURL {
    NSString *urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:kNestRedirectURLKey];
    return [NSURL URLWithString:urlString];
}

- (NSURL *)p_authorizationURL {
    NSString *urlString = [NSString stringWithFormat:kNestAuthorizationURLFormat, [self p_currentAPIDomain], [self p_clientID], [self p_state]];
    return [NSURL URLWithString:urlString];
}

- (NSURL *)p_accessTokenURLWithAuthorizationCode:(NSString *)authorizationCode {
    NSString *urlString = [NSString stringWithFormat:kNestAccessTokenURLFormat, [self p_currentAPIDomain], authorizationCode, [self p_clientID], [self p_clientSecret]];
    return [NSURL URLWithString:urlString];
}

- (NestSDKAuthorizationManagerAuthorizationResult *)p_authorizationResultWithData:(NSData *)data {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    NSString *tokenString = json[@"access_token"];
    NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:[json[@"expires_in"] longValue]];

    NestSDKAccessToken *accessToken = [[NestSDKAccessToken alloc] initWithTokenString:tokenString expirationDate:expirationDate];

    return [[NestSDKAuthorizationManagerAuthorizationResult alloc] initWithToken:accessToken isCancelled:NO];
}

- (void)p_obtainTokenWithAuthorizationCode:(NSString *)authorizationCode {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self p_accessTokenURLWithAuthorizationCode:authorizationCode]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"form-data" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    urlSessionConfiguration.allowsCellularAccess = YES;
    urlSessionConfiguration.timeoutIntervalForRequest = 8.0;
    urlSessionConfiguration.timeoutIntervalForResource = 8.0;

    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfiguration delegate:nil delegateQueue:nil];

    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       if (error) {
                                                           [self p_finishAuthorizationWithAuthorizationResult:nil error:error];

                                                       } else {
                                                           NestSDKAuthorizationManagerAuthorizationResult *authorizationResult = [self p_authorizationResultWithData:data];
                                                           [NestSDKAccessToken setCurrentAccessToken:authorizationResult.token];

                                                           [self p_finishAuthorizationWithAuthorizationResult:authorizationResult error:nil];
                                                       }
                                                   }];
    [dataTask resume];
}

- (void)p_finishAuthorizationWithAuthorizationResult:(NestSDKAuthorizationManagerAuthorizationResult *)authorizationResult error:(NSError *)error {
    if (!OSAtomicCompareAndSwapInt(YES, NO, &_authorizing)) return;

    if (_handler) _handler(authorizationResult, error);
    [_authorizationViewController dismissViewControllerAnimated:YES completion:nil];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark Notification selectors

#pragma mark Override

#pragma mark Public

- (void)authorizeWithNestAccountFromViewController:(UIViewController *)viewController
                                           handler:(NestSDKAuthorizationManagerAuthorizationHandler)handler {

    if (!OSAtomicCompareAndSwapInt(NO, YES, &_authorizing)) return;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    _handler = [handler copy];
    _authorizationViewController = [[NestSDKAuthorizationViewController alloc] initWithAuthorizationURL:[self p_authorizationURL]
                                                                                            redirectURL:[self p_redirectURL]
                                                                                               delegate:self];

    [viewController presentViewController:_authorizationViewController animated:YES completion:nil];
}

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate <NestSDKAuthorizationViewControllerDelegate>

- (void)hasCancelledAuthorization {
    NestSDKAuthorizationManagerAuthorizationResult *result = [[NestSDKAuthorizationManagerAuthorizationResult alloc] initWithToken:nil isCancelled:YES];
    [self p_finishAuthorizationWithAuthorizationResult:result error:nil];
}

- (void)hasReceivedAuthorizationCode:(NSString *)authorizationCode {
    [self p_obtainTokenWithAuthorizationCode:authorizationCode];
}

@end