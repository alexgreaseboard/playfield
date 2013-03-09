//
//  PlaySprite.h
//  PlayField
//
//  Created by Jai Lebo on 2/23/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "cocos2d.h"

@class Play, SpritePoint;

@interface PlaySprite : NSManagedObject

@property (nonatomic, strong) CCSprite *sprite;
@property CGPoint startingCGPosition;
@property int maxIndex;

@property (nonatomic, retain) NSString *startingPosition;
@property (nonatomic, retain) NSString *imageString;
@property (nonatomic, retain) Play *play;
@property (nonatomic, retain) NSOrderedSet *spritePoints;

@property (nonatomic, strong) NSMutableArray *toucharray; // Used during adjusting and running.  Later stored in spritePoints.

- (id)initFromDatabase;
- (id)initWithImage:(NSString *)image andPosition:(CGPoint)sPosition;
- (void)resetPath;
- (void)moveSpriteWithSpeed:(int)pSpeed;
- (void)resetSprite;
- (void)repositionSpriteWithPosition:(CGPoint)pPosition;
- (void)saveSpritePoints;

@end

@interface PlaySprite (CoreDataGeneratedAccessors)

- (void)insertObject:(SpritePoint *)value inSpritePointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSpritePointsAtIndex:(NSUInteger)idx;
- (void)insertSpritePoints:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSpritePointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSpritePointsAtIndex:(NSUInteger)idx withObject:(SpritePoint *)value;
- (void)replaceSpritePointsAtIndexes:(NSIndexSet *)indexes withSpritePoints:(NSArray *)values;
- (void)addSpritePointsObject:(SpritePoint *)value;
- (void)removeSpritePointsObject:(SpritePoint *)value;
- (void)addSpritePoints:(NSOrderedSet *)values;
- (void)removeSpritePoints:(NSOrderedSet *)values;

@end
