//
//  PurpleSegmentControl.m
//  greaseboard
//
//  Created by Emily Jeppson on 7/11/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PurpleSegmentControl.h"

@implementation PurpleSegmentControl{
    CAGradientLayer *shineLayer;
    CALayer         *highlightLayer;
}

- (void)initLayers {
    self.segmentedControlStyle = UISegmentedControlStyleBar;
    for(int i=0; i<[self.subviews count]; i++){
        UIView *view = [self.subviews objectAtIndex:i];
        CALayer *purpleLayer = [CALayer layer];
        purpleLayer.frame = view.layer.bounds;
        purpleLayer.backgroundColor =  [UIColor colorWithRed:39/255.0 green:21/255.0 blue:57/255.0 alpha:1.0].CGColor;
        [view.layer addSublayer:purpleLayer];
        
        shineLayer = [CAGradientLayer layer];
        shineLayer.frame = view.layer.bounds;
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
        [view.layer addSublayer:shineLayer];
    }
    //Create a dictionary to hold the new text attributes
    NSMutableDictionary * textAttributes = [[NSMutableDictionary alloc] init];
    //Add an entry to set the text to black
    [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    [self initBorder];
}

- (void)awakeFromNib {
    [self addTarget:self action:@selector(highlight:) forControlEvents:UIControlEventValueChanged];
    [self initLayers];
}

- (void)initBorder {
    CALayer *layer = self.layer;
    layer.cornerRadius = 4.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.6f].CGColor;
}

-(void) highlight:sender{
    if(highlightLayer){
        [highlightLayer removeFromSuperlayer];
    }
    for(int i=0; i<[self.subviews count]; i++){
        UIView *view = [self.subviews objectAtIndex:i];
        if([[self.subviews objectAtIndex:i] isSelected ]){
            highlightLayer = [CALayer layer];
            highlightLayer.backgroundColor = [UIColor colorWithRed:0.85f
                                                         green:0.85f
                                                          blue:0.85f
                                                         alpha:0.35].CGColor;
            highlightLayer.frame = view.layer.bounds;
            highlightLayer.hidden = NO;
            [view.layer insertSublayer:highlightLayer atIndex:2];
        } 
    }
}

@end
