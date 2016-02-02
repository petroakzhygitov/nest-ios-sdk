#import "DeviceIconView.h"

@implementation DeviceIconView
#pragma mark Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self initView];
}

#pragma mark Override

- (void)prepareForInterfaceBuilder {
    [self initView];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];

    [self recreateSublayers];
    [self resizeSubviews];
}

#pragma mark Public

- (void)initView {
    [self createBackgroundLayer];
    [self createSublayers];
    [self createSubviews];
}

- (void)createBackgroundLayer {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = self.bounds;
    
    [self.layer addSublayer:layer];

#if !TARGET_INTERFACE_BUILDER
    self.backgroundLayer = layer;
#endif
}

- (void)createSublayers {
}

- (void)createSubviews {
}

- (void)recreateSublayers {
    [self removeSublayers];
    [self createSublayers];
}

- (void)removeSublayers {
    [[self.backgroundLayer.sublayers copy] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)resizeSubviews {
}

- (void)addShadowWithColor:(UIColor *)shadowColor offset:(CGSize)shadowOffset opacity:(CGFloat)shadowOpacity
                    radius:(CGFloat)shadowRadius toLayer:(CALayer *)layer {

    layer.shadowColor = shadowColor.CGColor;
    layer.shadowOffset = shadowOffset;
    layer.shadowOpacity = shadowOpacity;
    layer.shadowRadius = shadowRadius;
}

- (void)addCircleLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth {
    CAShapeLayer *circleLayer = [self circleLayerWithRect:rect fillColor:fillColor strokeColor:strokeColor lineWidth:lineWidth];

    [self addLayer:circleLayer];
}

- (void)addCircleLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor {
    CAShapeLayer *circleLayer = [self circleLayerWithRect:rect fillColor:fillColor];

    [self addLayer:circleLayer];

}

- (void)addGradientCircleLayerWithRect:(CGRect)rect colors:(NSArray *)colors {
    CAGradientLayer *gradientLayer = [self gradientCircleLayerWithRect:rect colors:colors];

    [self addLayer:gradientLayer];
}

- (CAShapeLayer *)circleLayerWithRect:(CGRect)rect {
    return [self circleLayerWithRect:rect fillColor:[UIColor blackColor]];
}

- (CAShapeLayer *)circleLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor {
    return [self circleLayerWithRect:rect fillColor:fillColor strokeColor:[UIColor clearColor] lineWidth:1];
}

- (CAShapeLayer *)circleLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth {
    UIBezierPath *circlePath = [self circlePathWithRect:rect];

    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = circlePath.CGPath;
    circleLayer.fillColor = fillColor.CGColor;
    circleLayer.strokeColor = strokeColor.CGColor;
    circleLayer.lineWidth = lineWidth;

    return circleLayer;
}

- (UIBezierPath *)circlePathWithRect:(CGRect)rect {
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

- (CAGradientLayer *)gradientCircleLayerWithRect:(CGRect)rect colors:(NSArray *)colors {
    CAShapeLayer *circleLayer = [self circleLayerWithRect:rect];
    NSArray *cgColors = [self cgColorsArrayWithColorsArray:colors];

    return [self gradientLayerWithMaskLayer:circleLayer cgColors:cgColors];
}

- (NSArray *)cgColorsArrayWithColorsArray:(NSArray *)colorsArray {
    NSMutableArray *cgColorsArray = [[NSMutableArray alloc] initWithCapacity:colorsArray.count];
    for (UIColor *color in colorsArray) {
        [cgColorsArray addObject:(id) color.CGColor];
    }

    return cgColorsArray;
}

- (CAGradientLayer *)gradientLayerWithMaskLayer:(CALayer *)circleLayer cgColors:(NSArray *)cgColors {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = cgColors;
    gradientLayer.mask = circleLayer;

    return gradientLayer;
}

- (void)addLayer:(CALayer *)layer {
    [self.backgroundLayer addSublayer:layer];
}

- (CGRect)rectWithInset:(CGFloat)inset {
    return CGRectInset([self baseRect], inset, inset);
}

- (CGRect)baseRect {
    CGFloat baseInset = [self baseInset];
    return CGRectInset(self.bounds, baseInset, baseInset);
}

- (CGFloat)baseInset {
    return self.bounds.size.width * 0.03f;
}

@end