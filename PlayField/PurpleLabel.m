//
//  PurpleLabel.m
//  PlayField
//
//  Created by Emily Jeppson on 5/27/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PurpleLabel.h"

@implementation PurpleLabel


- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:39/255.0 green:21/255.0 blue:57/255.0 alpha:.95];
    [self initBorder];
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (void)initBorder {
    CALayer *layer = self.layer;
    layer.cornerRadius = 0.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.6f].CGColor;
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
