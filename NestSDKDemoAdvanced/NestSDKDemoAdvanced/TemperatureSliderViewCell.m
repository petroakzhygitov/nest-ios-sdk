#import "TemperatureSliderViewCell.h"

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

@interface TemperatureSliderViewCell ()

@property(nonatomic) UISlider *slider;
@property(nonatomic) UILabel *textLabel;

@property NSUInteger steps;

@end


@implementation TemperatureSliderViewCell

@synthesize textLabel = _textLabel;

#pragma mark Override

- (void)configure {
    self.steps = 0;
    [self.slider addTarget:self action:@selector(valueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderDidEndSliding:)
          forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];

    [self.contentView addSubview:self.slider];
    [self.contentView addSubview:self.textLabel];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:44]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:0 views:@{@"textLabel" : self.textLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|" options:0 metrics:0 views:@{@"slider" : self.slider}]];

    [self valueDidChange:nil];
}

- (void)update {
    [super update];

    self.slider.value = [self.rowDescriptor.value floatValue];
    self.slider.enabled = !self.rowDescriptor.isDisabled;

    [self valueDidChange:nil];
}

- (void)sliderDidEndSliding:(UISlider *)_slider {
    [self valueDidChange:_slider];

    self.rowDescriptor.value = @(self.slider.value);
}

- (void)valueDidChange:(UISlider *)_slider {
    if (self.steps != 0) {
        self.slider.value = roundf((self.slider.value - self.slider.minimumValue) / (self.slider.maximumValue - self.slider.minimumValue) * self.steps) * (self.slider.maximumValue - self.slider.minimumValue) / self.steps + self.slider.minimumValue;
    }

    self.textLabel.text = [NSString stringWithFormat:@"%@ %.1f", self.rowDescriptor.title, self.slider.value];
}

+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 88;
}


- (UILabel *)textLabel {
    if (_textLabel) return _textLabel;

    _textLabel = [UILabel autolayoutView];

    return _textLabel;
}

- (UISlider *)slider {
    if (_slider) return _slider;

    _slider = [UISlider autolayoutView];

    return _slider;
}

#pragma mark Public

#pragma mark IBAction

#pragma mark Protocol @protocol-name

#pragma mark Delegate @delegate-name

@end