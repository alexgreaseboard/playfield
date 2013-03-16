//
//  PracticeItem.m
//  PlayField
//
//  Created by Emily Jeppson on 3/9/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PracticeItem.h"
#import "PracticeColumn.h"
#import "PracticeItemCell.h"


@implementation PracticeItem

@dynamic itemName;
@dynamic numberOfMinutes;
@dynamic columnNumber;
@dynamic itemType;
@dynamic practiceColumn;

@synthesize backgroundColor;

- (void)createHeaderWithName:(NSString*)name
{
        // Initialization code
        // set a random background color
        //CGColorRef colorRef = [UIColor darkGrayColor].CGColor;
        //self.backgroundColor = [CIColor colorWithCGColor:colorRef].stringRepresentation;
        NSInteger height = HEADER_HEIGHT;
        self.numberOfMinutes = [NSNumber numberWithInt:height];
        self.itemType = @"header";
        self.itemName = name;
}

- (void)createTimeHeader{
        // Initialization code
        // set a random background color
        //CGColorRef colorRef = [UIColor whiteColor].CGColor;
        //self.backgroundColor = [CIColor colorWithCGColor:colorRef].stringRepresentation;
        NSInteger height = HEADER_HEIGHT;
        self.numberOfMinutes = [NSNumber numberWithInt:height];
        self.itemType = @"timeheader";
}

- (void)createTimeItemWithLabel:(NSString*)label{
        // Initialization code
        //CGColorRef colorRef = [UIColor clearColor].CGColor;
        //self.backgroundColor = [CIColor colorWithCGColor:colorRef].stringRepresentation;
        self.numberOfMinutes = [NSNumber numberWithInt:5];
        self.itemType = @"time";
        self.itemName = label;
}

@end
