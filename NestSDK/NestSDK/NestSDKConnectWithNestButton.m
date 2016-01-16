// Copyright (c) 2016 Petro Akzhygitov <petro.akzhygitov@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NestSDKConnectWithNestButton.h"
#import "NestSDKAuthorizationManager.h"
#import "UIColor+NestBlue.h"
#import "NestSDKAccessToken.h"
#import "NestSDKUtils.h"


@implementation NestSDKConnectWithNestButton {
#pragma mark Instance variables
    NestSDKAuthorizationManager *_authorizationManager;
}

#pragma mark Initializer

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

#pragma mark Private

- (void)_configureButton {
    _authorizationManager = [[NestSDKAuthorizationManager alloc] init];

    self.frame = CGRectMake(0, 0, 200, 32);
    self.adjustsImageWhenDisabled = NO;
    self.adjustsImageWhenHighlighted = NO;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.tintColor = [UIColor whiteColor];

//    BOOL forceSizeToFit = CGRectIsEmpty(self.bounds);

    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *backgroundImage;

    backgroundImage = [self _backgroundImageWithColor:[UIColor nestBlue] cornerRadius:16.0 scale:scale];
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    backgroundImage = [self _backgroundImageWithColor:[UIColor nestBlueSelected] cornerRadius:16.0 scale:scale];
    [self setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];

    backgroundImage = [self _backgroundImageWithColor:[UIColor lightGrayColor] cornerRadius:16.0 scale:scale];
    [self setBackgroundImage:backgroundImage forState:UIControlStateDisabled];

    backgroundImage = [self _backgroundImageWithColor:[UIColor nestBlueSelected] cornerRadius:16.0 scale:scale];
    [self setBackgroundImage:backgroundImage forState:UIControlStateSelected];

    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self setTitle:@"Connect with Nest" forState:UIControlStateNormal];
    [self setTitle:@"Disconnect" forState:UIControlStateSelected];
    [self setTitle:@"Disconnect" forState:UIControlStateHighlighted];

    UILabel *titleLabel = self.titleLabel;
    titleLabel.lineBreakMode = NSLineBreakByClipping;
    titleLabel.textAlignment = NSTextAlignmentCenter;

    UIFont *font = [UIFont boldSystemFontOfSize:16.0];
    titleLabel.font = font;

    [self _updateContent];

    [self addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenDidChangeNotification:)
                                                 name:NestSDKAccessTokenDidChangeNotification
                                               object:nil];
}

- (UIImage *)_backgroundImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius scale:(CGFloat)scale {
    CGFloat size = (CGFloat) (1.0 + 2 * cornerRadius);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, (CGFloat) (cornerRadius + 1.0), 0.0);
    CGPathAddArcToPoint(path, NULL, size, 0.0, size, cornerRadius, cornerRadius);
    CGPathAddLineToPoint(path, NULL, size, (CGFloat) (cornerRadius + 1.0));
    CGPathAddArcToPoint(path, NULL, size, size, (CGFloat) (cornerRadius + 1.0), size, cornerRadius);
    CGPathAddLineToPoint(path, NULL, cornerRadius, size);
    CGPathAddArcToPoint(path, NULL, 0.0, size, 0.0, (CGFloat) (cornerRadius + 1.0), cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0.0, cornerRadius);
    CGPathAddArcToPoint(path, NULL, 0.0, 0.0, cornerRadius, 0.0, cornerRadius);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [image stretchableImageWithLeftCapWidth:(NSInteger) cornerRadius topCapHeight:(NSInteger) cornerRadius];
}

//- (CGSize)sizeThatFits:(CGSize)size {
//    if ([self isHidden]) {
//        return CGSizeZero;
//    }
//
//    CGSize normalSize = [self sizeThatFits:size title:[self titleForState:UIControlStateNormal]];
//    CGSize selectedSize = [self sizeThatFits:size title:[self titleForState:UIControlStateSelected]];
//
//    return CGSizeMake(MAX(normalSize.width, selectedSize.width), MAX(normalSize.height, selectedSize.height));
//}
//
//- (void)sizeToFit {
//    CGRect bounds = self.bounds;
//    bounds.size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//    self.bounds = bounds;
//}
//
//- (CGSize)sizeThatFits:(CGSize)size title:(NSString *)title {
//    UIFont *font = self.titleLabel.font;
//    CGFloat height = [self _heightForFont:font];
//
//    UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
//
//    CGSize constrainedContentSize = FBSDKEdgeInsetsInsetSize(size, contentEdgeInsets);
//
//    CGSize titleSize = FBSDKTextSize(title, font, constrainedContentSize, self.titleLabel.lineBreakMode);
//
//    CGFloat padding = [self _paddingForHeight:height];
//    CGFloat textPaddingCorrection = [self _textPaddingCorrectionForHeight:height];
//    CGSize contentSize = CGSizeMake(height + padding + titleSize.width - textPaddingCorrection, height);
//
//    return FBSDKEdgeInsetsOutsetSize(contentSize, contentEdgeInsets);
//}

- (void)_updateContent {
    self.selected = ([NestSDKAccessToken currentAccessToken] != nil);
}

- (void)_accessTokenDidChangeNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self _updateContent];
    });
}

- (void)_buttonPressed:(id)_buttonPressed {
    if ([self.delegate respondsToSelector:@selector(loginButtonWillLogin:)]) {
        if (![self.delegate loginButtonWillLogin:self]) return;
    }

    if ([NestSDKAccessToken currentAccessToken]) {
        NSString *title = nil;

        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Disconnect from Nest"
                                                  otherButtonTitles:nil];
        [sheet showInView:self];

    } else {
        NestSDKAuthorizationManagerAuthorizationHandler handler = ^(NestSDKAuthorizationManagerAuthorizationResult *result, NSError *error) {
            if ([self.delegate respondsToSelector:@selector(connectWithNestButton:didCompleteWithResult:error:)]) {
                [self.delegate connectWithNestButton:self didCompleteWithResult:result error:error];
            }
        };

        [_authorizationManager authorizeWithNestAccountFromViewController:[NestSDKUtils viewControllerForView:self] handler:handler];
    }
}

#pragma mark Override

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [_authorizationManager unauthorize];

        [self.delegate loginButtonDidLogOut:self];
    }
}


@end