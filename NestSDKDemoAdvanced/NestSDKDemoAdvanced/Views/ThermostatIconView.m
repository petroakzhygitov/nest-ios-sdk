#import "ThermostatIconView.h"

#pragma mark const
static const int kInsetMultiplierBlackMiddleRect = 2;
static const int kInsetMultiplierDisplayRect = 8;
static const int kInsetMultiplierScaleRect = 6;
static const int kInsetMultiplierTemperatureLabelRect = 10;


@interface ThermostatIconView ()

@property(nonatomic, weak) UILabel *temperatureLabel;
@property(nonatomic) CAShapeLayer *displayLayer;

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

- (void)_addScaleCircleLayer {
    CGFloat inset = [self baseInset] * kInsetMultiplierScaleRect;
    CGRect circleRect = [self rectWithInset:inset];

    [self addCircleLayerWithRect:circleRect fillColor:[UIColor darkGrayColor]];
}

- (void)_addDisplayCircleLayer {
    CGFloat inset = [self baseInset] * kInsetMultiplierDisplayRect;
    CGRect circleRect = [self rectWithInset:inset];

    CAShapeLayer *circleLayer = [self circleLayerWithRect:circleRect fillColor:[UIColor blackColor]];
    [self addLayer:circleLayer];

    self.displayLayer = circleLayer;
}

#pragma mark Override

- (void)createSubviews {
    [self _addTemperatureLabel];
}

- (void)createSublayers {
    [self _addGrayOutlineCircleLayer];
    [self _addBlackMiddleCircleLayer];
    [self _addScaleCircleLayer];
    [self _addDisplayCircleLayer];
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

    self.displayLayer.fillColor = color.CGColor;
}

- (void)setTargetTemperatureValue:(NSNumber *)targetTemperatureValue {
    _targetTemperatureValue = targetTemperatureValue;

    self.temperatureLabel.text = targetTemperatureValue.stringValue;
}


@end