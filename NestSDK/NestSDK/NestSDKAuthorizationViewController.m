#import "NestSDKAuthorizationViewController.h"
#import "UIColor+NestBlue.h"

@interface NestSDKAuthorizationViewController () <UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;

@end

#define QUESTION_MARK @"?"
#define SLASH @"/"
#define HASHTAG @"#"
#define EQUALS @"="
#define AMPERSAND @"&"
#define EMPTY_STRING @""

@implementation NestSDKAuthorizationViewController

- (instancetype)initWithAuthorizationURL:(NSURL *)authorizationURL
                             redirectURL:(NSURL *)redirectURL
                                delegate:(id <NestSDKAuthorizationViewControllerDelegate>)delegate {
    self = [super init];
    if (self) {
        _authorizationURL = [authorizationURL copy];
        _redirectURL = [redirectURL copy];
        _delegate = delegate;
    }

    return self;
}


/**
 * Setup the UI Elements.
 */
- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Add a navbar to the top
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navBar];

    // Add some items to the navigation bar
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Connect with Nest"];
    navItem.leftBarButtonItem = bbi;
    [navBar pushNavigationItem:navItem animated:YES];

    // Add a uiwebview to take up the entire view (beneath the nav bar)
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64)];
    [self.webView setBackgroundColor:[UIColor nestBlue]];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];

//    self.webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [self.webView setBackgroundColor:[UIColor nestBlue]];
//    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
//    [self.view addSubview:self.webView];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (object == self.webView && [keyPath isEqualToString:@"URL"]) {
//        NSLog(@"URL Changed to: %@", self.webView.URL.absoluteString);
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the title
    self.title = @"Connect With Nest";

    // Load the URL in the web view
    [self loadAuthURL];
}

/**
 * Load's the auth url in the web view.
 */
- (void)loadAuthURL {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.authorizationURL];
    [self.webView loadRequest:request];
}

/**
 * Cancel button is hit.
 * @param sender The button that was hit.
 */
- (void)cancel:(UIButton *)sender {
    [self.delegate hasCancelledAuthorization];
}

#pragma mark UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/**
 * Intercept the requests to get the authorization code.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSURL *redirectURL = self.redirectURL;

    if ([[url host] isEqualToString:[redirectURL host]]) {

        // Clean the string
        NSString *urlResources = [url resourceSpecifier];
        urlResources = [urlResources stringByReplacingOccurrencesOfString:QUESTION_MARK withString:EMPTY_STRING];
        urlResources = [urlResources stringByReplacingOccurrencesOfString:HASHTAG withString:EMPTY_STRING];

        // Seperate the /
        NSArray *urlResourcesArray = [urlResources componentsSeparatedByString:SLASH];

        // Get all the parameters after /
        NSString *urlParamaters = [urlResourcesArray objectAtIndex:([urlResourcesArray count] - 1)];

        // Separate the &
        NSArray *urlParamatersArray = [urlParamaters componentsSeparatedByString:AMPERSAND];
        NSString *keyValue = [urlParamatersArray lastObject];
        NSArray *keyValueArray = [keyValue componentsSeparatedByString:EQUALS];

        // We found the code
        if ([[keyValueArray objectAtIndex:(0)] isEqualToString:@"code"]) {

            // Send it to the delegate
            [self.delegate hasReceivedAuthorizationCode:keyValueArray[1]];

        } else {
            NSLog(@"Error retrieving the authorization code.");
        }

        return NO;
    }

    return YES;
}


@end
