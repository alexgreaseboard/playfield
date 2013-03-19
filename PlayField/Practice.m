//
//  Practice.m
//  PlayField
//
//  Created by Emily Jeppson on 3/9/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "Practice.h"
#import "PracticeColumn.h"


@implementation Practice

@dynamic practiceName;
@dynamic practiceDuration;
@dynamic practiceColumns;

// overwritten because of a bug that apple hasn't fixed
- (void)addPracticeColumnsObject:(PracticeColumn *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.practiceColumns];
    [tempSet addObject:value];
    self.practiceColumns = tempSet;
}

- (void)removePracticeColumnsObject:(PracticeColumn *)value{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.practiceColumns];
    [tempSet removeObject:value];
    self.practiceColumns = tempSet;
}
@end
