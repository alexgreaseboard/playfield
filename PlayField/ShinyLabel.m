//
//  ShinyLabel.m
//  PlayField
//
//  Created by Emily Jeppson on 5/27/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "ShinyLabel.h"

@implementation ShinyLabel{
    CAGradientLayer *shineLayer;
    CALayer         *highlightLayer;
}

- (void)awakeFromNib {
    [self initLayers];
}

- (void)initLayers {
    [self addShineLayer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addShineLayer {
    shineLayer = [CAGradientLayer layer];
    shineLayer.frame = self.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.3f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.15f],
                            [NSNumber numberWithFloat:0.4f],
                            nil];
    [self.layer addSublayer:shineLayer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
