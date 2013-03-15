//
//  PracticeItemCell.m
//  Flicker Search
//
//  Created by Emily Jeppson on 2/18/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import "PracticeItemCell.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@implementation PracticeItemCell

-(void)configureCellForPracticeItem:(PracticeItem*)practiceItem withframe:(CGRect)frame{
    //configure the cell
    UIView *foundLabel = [self viewWithTag:55];
    if (foundLabel) [foundLabel removeFromSuperview];
    foundLabel = [self viewWithTag:56];
    if (foundLabel) [foundLabel removeFromSuperview];
    
    //header
    if([practiceItem.itemType isEqualToString:@"header"]){
        [self addHeaderCellLabel:practiceItem withFrame:frame];
        [self addRoundedCorners];
        self.backgroundColor = [UIColor colorWithRed:20.0 green:100 blue:28.7 alpha:0];
    }
    //practice item
    else if([practiceItem.itemType isEqualToString:@"item"]){
        [self addItemCellLabel:practiceItem withFrame:frame];
        [self addDurationLabel:practiceItem withFrame:frame];
        [self addRoundedCorners];        
    } else if([practiceItem.itemType isEqualToString:@"time"]){
        //time
        CALayer *layer = [self layer];

        [self addTimeCellLabel:practiceItem withFrame:frame];
        layer.borderWidth = 0;
    } else {
        // time header
        [self addTimeCellLabel:practiceItem withFrame:frame];
        CALayer *layer = [self layer];
        layer.borderWidth = 0;
    }
    
    // background color
    // TODO background color
    //self.backgroundColor = practiceItem.backgroundColor;
}

-(void)addRoundedCorners{
    // rounded corners, shadow
    CALayer *layer = [self layer];
    [layer setCornerRadius:5.0f];
    [layer setBorderColor:[UIColor blackColor].CGColor];
    [layer setBorderWidth:1.0f];
}

-(void)addHeaderCellLabel:(PracticeItem*) practiceItem withFrame:(CGRect)frame{
    // cell label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
    self.label.tag=55;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont boldSystemFontOfSize:16.0];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.text = practiceItem.itemName;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    self.label.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.label];
}

-(void)addItemCellLabel:(PracticeItem*) practiceItem withFrame:(CGRect)frame{
    // cell label
    self.label = [self createStyledLabel:frame withOffset:0];

    self.label.tag=55;
    self.label.font = [UIFont boldSystemFontOfSize:16.0];
    self.label.text = [NSString stringWithFormat:@"  %@", practiceItem.itemName];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    self.label.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.label];
}

-(void)addTimeCellLabel:(PracticeItem*) practiceItem withFrame:(CGRect)frame{
    // cell label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 0.0, frame.size.width, 20)];
    self.label.tag=55;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.text = practiceItem.itemName;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    self.label.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.label];
    
}

-(void)addDurationLabel:(PracticeItem*) practiceItem withFrame:(CGRect)frame{
    UIView *foundLabel = [self viewWithTag:56];
    if (foundLabel) [foundLabel removeFromSuperview];
    self.durationLabel = [self createStyledLabel:frame withOffset:20];
    self.durationLabel.tag=56;
    self.durationLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.durationLabel.text = [NSString stringWithFormat:@"   %@ minutes", practiceItem.numberOfMinutes];
    self.durationLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    self.durationLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.durationLabel];
}

-(UILabel*)createStyledLabel:(CGRect)frame withOffset:(int)offset{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, offset,
                                                           frame.size.width, 20)];
    l.textColor = [UIColor lightTextColor];
    l.textAlignment = NSTextAlignmentLeft;
    l.textColor = [UIColor lightTextColor];
    l.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.65];
    
    return l;
}
@end
