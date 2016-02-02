#import "SmokeCOAlarmIconView.h"

#pragma mark const
static const int kInsetMultiplierDeviceCircle = 4;


@interface SmokeCOAlarmIconView ()

@property(nonatomic) CAGradientLayer *outlineColorGradientLayer;

@end


@implementation SmokeCOAlarmIconView
#pragma mark Private

- (void)_addOutlineColorStrokeCircleLayer {
    CGFloat inset = [self baseInset];
    CGRect circleRect = [self rectWithInset:inset];

    [self addCircleLayerWithRect:circleRect fillColor:[UIColor clearColor] strokeColor:[self _darkGreenColor] lineWidth:1];
}

- (void)_addOutlineColorGradientCircleLayer {
    CGFloat inset = [self baseInset];
    CGRect circleRect = [self rectWithInset:inset];

    CAGradientLayer *gradientLayer = [self gradientCircleLayerWithRect:circleRect colors:@[[self _lightGreenColor], [self _darkGreenColor]]];
    [self addLayer:gradientLayer];

    self.outlineColorGradientLayer = gradientLayer;
}

- (void)_addDeviceCircleLayer {
    CGFloat inset = [self baseInset] * kInsetMultiplierDeviceCircle;
    CGRect circleRect = [self rectWithInset:inset];

    CAShapeLayer *layer = [self circleLayerWithRect:circleRect fillColor:[UIColor whiteColor] strokeColor:[UIColor lightGrayColor] lineWidth:1];
    [self addShadowWithColor:[UIColor darkGrayColor] offset:CGSizeMake(0, 2.0) opacity:.8 radius:4 toLayer:layer];

    [self addLayer:layer];
}

#pragma mark Override

- (void)createSublayers {
    [self _addOutlineColorStrokeCircleLayer];
    [self _addOutlineColorGradientCircleLayer];
    [self _addDeviceCircleLayer];
}

- (void)setColor:(SmokeCOAlarmIconViewColor)color {
    _color = color;

    NSArray *colorsArray = @[];

    switch (color) {
        case SmokeCOAlarmIconViewColorGreen:
            colorsArray = [self _greenColorsArray];

            break;
        case SmokeCOAlarmIconViewColorYellow:
            colorsArray = [self _yellowColorsArray];

            break;
        case SmokeCOAlarmIconViewColorRed:
            colorsArray = [self _redColorsArray];

            break;
        case SmokeCOAlarmIconViewColorGray:
            colorsArray = [self _grayColorsArray];

            break;
    }

    self.outlineColorGradientLayer.colors = [self cgColorsArrayWithColorsArray:colorsArray];
}

- (NSArray *)_greenColorsArray {
    return @[[self _lightGreenColor], [self _darkGreenColor]];
}

- (NSArray *)_yellowColorsArray {
    return @[[self _lightYellowColor], [self _darkYellowColor]];
}

- (NSArray *)_redColorsArray {
    return @[[self _lightRedColor], [self _darkRedColor]];
}

- (NSArray *)_grayColorsArray {
    return @[[UIColor lightGrayColor], [UIColor darkGrayColor]];
}

- (UIColor *)_lightGreenColor {
    return [UIColor colorWithRed:131.0f / 255.0f green:233.0f / 255.0f blue:54.0f / 255.0f alpha:1];
}

- (UIColor *)_darkGreenColor {
    return [UIColor colorWithRed:0 green:212.0f / 255.0f blue:0 alpha:1];
}

- (UIColor *)_lightYellowColor {
    return [UIColor colorWithRed:131.0f / 255.0f green:233.0f / 255.0f blue:54.0f / 255.0f alpha:1];
}

- (UIColor *)_darkYellowColor {
    return [UIColor colorWithRed:0 green:212.0f / 255.0f blue:0 alpha:1];
}

- (UIColor *)_lightRedColor {
    return [UIColor colorWithRed:131.0f / 255.0f green:233.0f / 255.0f blue:54.0f / 255.0f alpha:1];
}

- (UIColor *)_darkRedColor {
    return [UIColor colorWithRed:0 green:212.0f / 255.0f blue:0 alpha:1];
}

@end