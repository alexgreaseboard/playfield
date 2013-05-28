//
//  CustomButton.m
//  PlayField
//
//  Created by Emily Jeppson on 5/27/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton{
    CAGradientLayer *shineLayer;
    CALayer         *highlightLayer;
}

- (void)initLayers {
    self.backgroundColor = [UIColor colorWithRed:39/255.0 green:21/255.0 blue:57/255.0 alpha:1.0];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self initBorder];
    [self addShineLayer];
    [self addHighlightLayer];
}

- (void)awakeFromNib {
    [self initLayers];
}

- (void)initBorder {
    CALayer *layer = self.layer;
    layer.cornerRadius = 4.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.6f].CGColor;
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
                            [NSNumber numberWithFloat:0.4f],
                            [NSNumber numberWithFloat:0.4f],
                            nil];
    [self.layer addSublayer:shineLayer];
}

// for when the button is selected
- (void)addHighlightLayer {
    if(self.enabled){
    highlightLayer = [CALayer layer];
    highlightLayer.backgroundColor = [UIColor colorWithRed:0.25f
                                                     green:0.25f
                                                      blue:0.25f
                                                     alpha:0.45].CGColor;
    highlightLayer.frame = self.layer.bounds;
    highlightLayer.hidden = YES;
    [self.layer insertSublayer:highlightLayer below:shineLayer];
    }
}

- (void)setHighlighted:(BOOL)highlight {
    highlightLayer.hidden = !highlight;
    [super setHighlighted:highlight];
}

- (void) setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if(enabled == YES){
        self.alpha = 1;
    } else {
        self.alpha = 0.7f;    }
}
@end
