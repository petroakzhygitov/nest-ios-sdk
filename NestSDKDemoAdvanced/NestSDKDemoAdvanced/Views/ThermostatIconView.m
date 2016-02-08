#import "ThermostatIconView.h"

#define DEGREES_TO_RADIANS(degrees)(CGFloat)((M_PI * degrees)/180)

#pragma mark const
static const int kInsetMultiplierBlackMiddleRect = 2;
static const int kInsetMultiplierDisplayRect = 8;
static const int kInsetMultiplierScaleRect = 6;
static const int kInsetMultiplierTemperatureLabelRect = 11;
static const int kInsetMultiplierCircleDotRect = 15;
static const int kInsetMultiplierCircleDotShift = 7;


@interface ThermostatIconView ()

@property(nonatomic, weak) UILabel *temperatureLabel;

@property(nonatomic) CAShapeLayer *displayLayer;
@property(nonatomic) CAShapeLayer *displayBackgroundLayer;

@property(nonatomic) CAShapeLayer *leafLayer;
@property(nonatomic) CAShapeLayer *fanLayer;

@end


@implementation ThermostatIconView
#pragma mark Initializer

- (void)_addTemperatureLabel {
    UILabel *label = [[UILabel alloc] init];
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:100];
    label.text = @"42";

    [self addSubview:label];

    self.temperatureLabel = label;

    [self _resizeTemperatureLabel];
}

- (void)_resizeTemperatureLabel {
    CGFloat inset = [self baseInset] * kInsetMultiplierTemperatureLabelRect;
    CGRect displayRect = [self rectWithInset:inset];

    self.temperatureLabel.frame = displayRect;
}

#pragma mark Private

- (void)_addGrayOutlineCircleLayer {
    CGFloat inset = [self baseInset];
    CGRect circleRect = [self rectWithInset:inset];

    [self addCircleLayerWithRect:circleRect fillColor:[UIColor lightGrayColor] strokeColor:[UIColor darkGrayColor] lineWidth:1];
}

- (void)_addBlackMiddleCircleLayer {
    CGFloat inset = [self baseInset] * kInsetMultiplierBlackMiddleRect;
    CGRect circleRect = [self rectWithInset:inset];

    [self addGradientCircleLayerWithRect:circleRect colors:@[[UIColor darkGrayColor], [UIColor blackColor]]];
}

- (void)_addDisplayBackgroundCircleLayer {
    CGFloat inset = [self baseInset] * kInsetMultiplierScaleRect;
    CGRect circleRect = [self rectWithInset:inset];

    CAShapeLayer *circleLayer = [self circleLayerWithRect:circleRect fillColor:[UIColor blackColor]];
    [self addLayer:circleLayer];

    self.displayBackgroundLayer = circleLayer;
}

- (void)_addScaleCircleLayer {
    CGFloat inset = [self baseInset] * kInsetMultiplierScaleRect;
    CGRect circleRect = [self rectWithInset:inset];

    UIColor *grayColor = [UIColor colorWithRed:128.0f / 255.0f green:128.0f / 255.0f blue:128.0f / 255.0f alpha:.5];
    [self _addArcLayerWithRect:circleRect fillColor:grayColor];
}

- (void)_addArcLayerWithRect:(CGRect)rect fillColor:(UIColor *)fillColor {
    CAShapeLayer *arcLayer = [self _arcLayerWithRect:rect fillColor:fillColor];

    [self addLayer:arcLayer];
}

- (CAShapeLayer *)_arcLayerWithRect:(CGRect)rect fillColor:(UIColor *)color {
    CGMutablePathRef arc = CGPathCreateMutable();
    CGFloat centerX = (CGFloat) (rect.origin.x + rect.size.width * .5);
    CGFloat centerY = (CGFloat) (rect.origin.y + rect.size.height * .5);
    CGPathMoveToPoint(arc, NULL, centerX, centerY);

    CGFloat radius = (CGFloat) (rect.size.width * .5);
    CGPathAddArc(arc, NULL, centerX, centerY, radius, DEGREES_TO_RADIANS(60), DEGREES_TO_RADIANS(120), YES);

    CAShapeLayer *arcLayer = [CAShapeLayer layer];
    arcLayer.fillColor = color.CGColor;
    arcLayer.path = arc;

    return arcLayer;
}

- (void)_addDisplayCircleLayer {
    CGFloat inset = [self baseInset] * kInsetMultiplierDisplayRect;
    CGRect circleRect = [self rectWithInset:inset];

    CAShapeLayer *circleLayer = [self circleLayerWithRect:circleRect fillColor:[UIColor blackColor]];
    [self addLayer:circleLayer];

    self.displayLayer = circleLayer;
}

- (void)_addLeafLayer {
    CAShapeLayer *leafLayer = [self _addCircleDotLayerWithColor:[UIColor greenColor]];

    self.leafLayer = leafLayer;
}

- (void)_addFanLayer {
    CAShapeLayer *fanLayer = [self _addCircleDotLayerWithColor:[UIColor whiteColor]];

    self.fanLayer = fanLayer;
}

- (CAShapeLayer *)_addCircleDotLayerWithColor:(UIColor *)color {
    CGFloat inset = [self baseInset] * kInsetMultiplierCircleDotRect;
    CGRect circleRect = [self rectWithInset:inset];
    circleRect.origin.y += [self baseInset] * kInsetMultiplierCircleDotShift;

    CAShapeLayer *circleDotLayer = [self circleLayerWithRect:circleRect fillColor:color];
    circleDotLayer.hidden = YES;

    [self addLayer:circleDotLayer];

    return circleDotLayer;
}

#pragma mark Override

- (void)createSubviews {
    [self _addTemperatureLabel];
}

- (void)createSublayers {
    [self _addGrayOutlineCircleLayer];
    [self _addBlackMiddleCircleLayer];
    [self _addDisplayBackgroundCircleLayer];
    [self _addScaleCircleLayer];
    [self _addDisplayCircleLayer];
    [self _addLeafLayer];
    [self _addFanLayer];
}

- (void)resizeSubviews {
    [self _resizeTemperatureLabel];
}

- (void)setState:(ThermostatIconViewState)state {
    _state = state;

    UIColor *color = [UIColor blackColor];
    switch (state) {
        case ThermostatIconViewStateOff:
            color = [UIColor blackColor];

            break;
        case ThermostatIconViewStateHeating:
            color = [UIColor orangeColor];

            break;
        case ThermostatIconViewStateCooling:
            color = [UIColor blueColor];

            break;
    }

    self.displayBackgroundLayer.fillColor = color.CGColor;
    self.displayLayer.fillColor = color.CGColor;
}

- (void)setTargetTemperatureValue:(NSNumber *)targetTemperatureValue {
    _targetTemperatureValue = targetTemperatureValue;

    self.temperatureLabel.text = targetTemperatureValue.stringValue;
}

- (void)setHasLeaf:(BOOL)hasLeaf {
    _hasLeaf = hasLeaf;

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.leafLayer.hidden = !hasLeaf;
    });
}

- (void)setHasFan:(BOOL)hasFan {
    _hasFan = hasFan;

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.fanLayer.hidden = !hasFan;
    });
}


@end