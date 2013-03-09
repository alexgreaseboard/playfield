//
//  PracticeItemCell.h
//  Flicker Search
//
//  Created by Emily Jeppson on 2/18/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PracticeItem.h"

@interface PracticeItemCell : UICollectionViewCell

#define HEADER_HEIGHT 60; // THE DEFault header height in pixels


@property (retain, nonatomic) UILabel* label;
@property (retain, nonatomic) UILabel* durationLabel;

-(void)configureCellForPracticeItem:(PracticeItem*)practiceItem withframe:(CGRect)frame;
@end
