//
//  Practice.h
//  PlayField
//
//  Created by Emily Jeppson on 3/9/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PracticeColumn;

@interface Practice : NSManagedObject

@property (nonatomic, retain) NSString * practiceName;
@property (nonatomic, retain) NSNumber * practiceDuration;
@property (nonatomic, retain) NSOrderedSet *practiceColumns;
@end

@interface Practice (CoreDataGeneratedAccessors)

- (void)insertObject:(PracticeColumn *)value inPracticeColumnsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPracticeColumnsAtIndex:(NSUInteger)idx;
- (void)insertPracticeColumns:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePracticeColumnsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPracticeColumnsAtIndex:(NSUInteger)idx withObject:(PracticeColumn *)value;
- (void)replacePracticeColumnsAtIndexes:(NSIndexSet *)indexes withPracticeColumns:(NSArray *)values;
- (void)addPracticeColumnsObject:(PracticeColumn *)value;
- (void)removePracticeColumnsObject:(PracticeColumn *)value;
- (void)addPracticeColumns:(NSOrderedSet *)values;
- (void)removePracticeColumns:(NSOrderedSet *)values;
@end
