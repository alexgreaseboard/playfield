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

// overwritten because of a bug in default core data
- (void)addPracticeItemsObject:(PracticeItem *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.practiceItems];
    [tempSet addObject:value];
    self.practiceItems = tempSet;
}

// overwritten because of a bug in default core data
- (void)insertObject:(PracticeItem *)value inPracticeItemsAtIndex:(NSUInteger)idx{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.practiceItems];
    [tempSet insertObject:value atIndex:idx];
    self.practiceItems = tempSet;
}

- (void)removePracticeItemsObject:(PracticeItem *)value{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.practiceItems];
    [tempSet removeObject:value];
    self.practiceItems = tempSet;
}
@end
