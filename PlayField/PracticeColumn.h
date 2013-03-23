//
//  PracticeColumn.h
//  PlayField
//
//  Created by Emily Jeppson on 3/9/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Practice, PracticeItem;

@interface PracticeColumn : NSManagedObject

@property (nonatomic, retain) NSString *columnName;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) Practice *practice;
@property (nonatomic, retain) NSOrderedSet *practiceItems;

@property (nonatomic, strong) NSMutableArray *timePracticeItems; // not saved

@end

@interface PracticeColumn (CoreDataGeneratedAccessors)


- (void)insertObject:(PracticeItem *)value inPracticeItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPracticeItemsAtIndex:(NSUInteger)idx;
- (void)insertPracticeItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePracticeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPracticeItemsAtIndex:(NSUInteger)idx withObject:(PracticeItem *)value;
- (void)replacePracticeItemsAtIndexes:(NSIndexSet *)indexes withPracticeItems:(NSArray *)values;
- (void)addPracticeItemsObject:(PracticeItem *)value;
- (void)removePracticeItemsObject:(PracticeItem *)value;
- (void)addPracticeItems:(NSOrderedSet *)values;
- (void)removePracticeItems:(NSOrderedSet *)values;
@end
