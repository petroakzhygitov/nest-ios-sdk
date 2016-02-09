#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeviceIconView : UIView
#pragma mark Methods

@property(nonatomic, strong) CALayer *backgroundLayer;

- (void)initView;


- (void)createSublayers;

- (void)recreateSublayers;

- (void)removeSublayers;


- (void)createSubviews;

- (void)resizeSubviews;


- (void)addShadowWithColor:(UIColor *)shadowColor offset:(CGSize)shadowOffset opacity:(CGFloat)shadowOpacity radius:(CGFloat)shadowRadius
                   toLayer:(CALayer *)layer;

- (void)addCircleLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;

- (void)addCircleLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor;

- (void)addGradientCircleLayerWithRect:(CGRect)rect colors:(NSArray *)colors;


- (UIBezierPath *)circlePathWithRect:(CGRect)rect;


- (CAShapeLayer *)circleLayerWithRect:(CGRect)rect;

- (CAShapeLayer *)circleLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor;

- (CAShapeLayer *)circleLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;


- (CAGradientLayer *)gradientCircleLayerWithRect:(CGRect)rect colors:(NSArray *)colors;


- (void)addLayer:(CALayer *)layer;


- (NSArray *)cgColorsArrayWithColorsArray:(NSArray *)colorsArray;


- (CGRect)rectWithInset:(CGFloat)inset;


- (CGFloat)baseInset;

- (CGRect)baseRect;

@end