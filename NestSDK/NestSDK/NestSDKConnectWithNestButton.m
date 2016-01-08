#import "NestSDKConnectWithNestButton.h"
#import "NestSDKAuthorizationManager.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef


@implementation NestSDKConnectWithNestButton {
#pragma mark Instance variables
}

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _configureButton];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _configureButton];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)_configureButton {
    NestSDKAuthorizationManager *authorizationManager = [[NestSDKAuthorizationManager alloc] init];
//
//    NSString *logInTitle = [self _shortLogInTitle];
//    NSString *logOutTitle = [self _logOutTitle];
//
//    [self configureWithIcon:nil
//                      title:logInTitle
//            backgroundColor:[super defaultBackgroundColor]
//           highlightedColor:nil
//              selectedTitle:logOutTitle
//               selectedIcon:nil
//              selectedColor:[super defaultBackgroundColor]
//   selectedHighlightedColor:nil];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//
//    [self _updateContent];
//
//    [self addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(_acessTokenDidChangeNotification:)
//                                                 name:FBSDKAccessTokenDidChangeNotification
//                                               object:nil];
}

- (void)_buttonPressed:(id)_buttonPressed {

}


@end