//
//  Play.h
//  PlayField
//
//  Created by Jai Lebo on 2/23/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Play : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * runPass;
@property (nonatomic, retain) NSNumber *order;
@property (nonatomic, retain) NSOrderedSet *playSprite;
@end

@interface Play (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inPlaySpriteAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPlaySpriteAtIndex:(NSUInteger)idx;
- (void)insertPlaySprite:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePlaySpriteAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPlaySpriteAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replacePlaySpriteAtIndexes:(NSIndexSet *)indexes withPlaySprite:(NSArray *)values;
- (void)addPlaySpriteObject:(NSManagedObject *)value;
- (void)removePlaySpriteObject:(NSManagedObject *)value;
- (void)addPlaySprite:(NSOrderedSet *)values;
- (void)removePlaySprite:(NSOrderedSet *)values;
@end
