//
//  PracticeColumn.m
//  PlayField
//
//  Created by Emily Jeppson on 3/9/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PracticeColumn.h"
#import "Practice.h"
#import "PracticeItem.h"


@implementation PracticeColumn

@dynamic columnName;
@dynamic color;
@dynamic practice;
@dynamic practiceItems;
@synthesize timePracticeItems;

// overwritten because of a bug that apple hasn't fixed
- (void)addPracticeItemsObject:(PracticeItem *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.practiceItems];
    [tempSet addObject:value];
    self.practiceItems = tempSet;
}

@end
