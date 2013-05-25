//
//  Play.h
//  PlayField
//
//  Created by Jai Lebo on 5/25/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlaySprite, PlaybookPlay;

@interface Play : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * runPass;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSOrderedSet *playSprite;
@property (nonatomic, retain) PlaybookPlay *playbookplay;
@end

@interface Play (CoreDataGeneratedAccessors)

- (void)insertObject:(PlaySprite *)value inPlaySpriteAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPlaySpriteAtIndex:(NSUInteger)idx;
- (void)insertPlaySprite:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePlaySpriteAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPlaySpriteAtIndex:(NSUInteger)idx withObject:(PlaySprite *)value;
- (void)replacePlaySpriteAtIndexes:(NSIndexSet *)indexes withPlaySprite:(NSArray *)values;
- (void)addPlaySpriteObject:(PlaySprite *)value;
- (void)removePlaySpriteObject:(PlaySprite *)value;
- (void)addPlaySprite:(NSOrderedSet *)values;
- (void)removePlaySprite:(NSOrderedSet *)values;
@end
