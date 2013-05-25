//
//  Playbook.h
//  PlayField
//
//  Created by Jai Lebo on 5/25/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PlaybookPlay.h"

@class PlaybookPlay;

@interface Playbook : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSOrderedSet *playbookplays;
@property (nonatomic, retain) NSNumber *displayOrder;
@end

@interface Playbook (CoreDataGeneratedAccessors)
- (void)insertObject:(PlaybookPlay *)value inPlaybookplaysAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPlaybookplaysAtIndex:(NSUInteger)idx;
- (void)insertPlaybookplays:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePlaybookplaysAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPlaybookplaysAtIndex:(NSUInteger)idx withObject:(PlaybookPlay *)value;
- (void)replacePlaybookplaysAtIndexes:(NSIndexSet *)indexes withPlaybookplays:(NSArray *)values;
- (void)addPlaybookplaysObject:(PlaybookPlay *)value;
- (void)removePlaybookplaysObject:(PlaybookPlay *)value;
- (void)addPlaybookplays:(NSOrderedSet *)values;
- (void)removePlaybookplays:(NSOrderedSet *)values;

@end
