#import "CameraIconView.h"

@interface CameraIconView ()

@property(nonatomic) CAShapeLayer *streamingLEDLayer;

@end


@implementation CameraIconView
#pragma mark Private

- (void)_addGrayOutlineCircleLayer {
    CGFloat inset = [self baseInset];
    CGRect circleRect = [self rectWithInset:inset];

    [self addCircleLayerWithRect:circleRect fillColor:[UIColor lightGrayColor] strokeColor:[UIColor darkGrayColor] lineWidth:1];
}

- (void)_addBlackMiddleCircleLayer {
    CGFloat inset = [self baseInset] * 4;
    CGRect circleRect = [self rectWithInset:inset];

    CAShapeLayer *layer = [self circleLayerWithRect:circleRect fillColor:[UIColor blackColor]];
    [self addShadowWithColor:[UIColor blackColor] offset:CGSizeMake(0, 2.0) opacity:.8 radius:4 toLayer:layer];

    [self addLayer:layer];
}

- (void)_addGrayLensOutline {
    CGFloat inset = [self baseInset] * 11;
    CGRect circleRect = [self rectWithInset:inset];

    [self addCircleLayerWithRect:circleRect fillColor:[UIColor darkGrayColor]];
}

- (void)_addLensOutlineLayer {
    CGFloat inset = [self baseInset] * 12;
    CGRect circleRect = [self rectWithInset:inset];

    [self addGradientCircleLayerWithRect:circleRect colors:@[[UIColor lightGrayColor], [UIColor blackColor]]];
}

- (void)_addLensLayer {
    CGFloat inset = [self baseInset] * 14;
    CGRect circleRect = [self rectWithInset:inset];

    [self addCircleLayerWithRect:circleRect fillColor:[UIColor blackColor]];
}

- (void)_addStreamingLEDLayer {
    CGFloat inset = [self baseInset] * 15;
    CGRect circleRect = [self rectWithInset:inset];
    circleRect.origin.y -= [self baseInset] * 8;

    CAShapeLayer *streamingLEDLayer = [self circleLayerWithRect:circleRect fillColor:[UIColor greenColor]];
    [self addLayer:streamingLEDLayer];

    self.streamingLEDLayer = streamingLEDLayer;
}

#pragma mark Override

- (void)createSublayers {
    [self _addGrayOutlineCircleLayer];
    [self _addBlackMiddleCircleLayer];

    [self _addGrayLensOutline];

    [self _addLensOutlineLayer];
    [self _addLensLayer];

    [self _addStreamingLEDLayer];
}

- (void)setStreaming:(BOOL)streaming {
    _streaming = streaming;

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.streamingLEDLayer.hidden = !streaming;
    });
}

@end