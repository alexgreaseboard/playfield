//
//  PlaySprite.m
//  PlayField
//
//  Created by Jai Lebo on 2/23/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaySprite.h"
#import "Play.h"
#import "SpritePoint.h"


@implementation PlaySprite
{
    int speed;
    int currentIndex;
}

@dynamic startingPosition;
@dynamic play;
@dynamic spritePoints;
@dynamic imageString;

@synthesize maxIndex;
@synthesize sprite;
@synthesize startingCGPosition;
@synthesize toucharray;
@synthesize red;
@synthesize blue;
@synthesize green;

- (id)initFromDatabase
{
    if( self.imageString == nil ) {
        self.sprite = [CCSprite node];
        CCTexture2D *tex = [[CCTexture2D alloc] initWithData:nil pixelFormat:kCCTexture2DPixelFormat_RGB5A1 pixelsWide:1 pixelsHigh:1 contentSize:CGSizeMake(1, 1)];
        [self.sprite setTexture:tex];
        [self.sprite setTextureRect:CGRectMake(0, 0, 1, 1)];
    } else {
        self.sprite = [CCSprite spriteWithFile:self.imageString];
    }
    self.startingCGPosition = CGPointFromString(self.startingPosition);
    self.sprite.position = self.startingCGPosition;

    self.toucharray = [[NSMutableArray alloc] init];
    currentIndex = 0;

    for(SpritePoint *sp in self.spritePoints) {
        [self.toucharray addObject:sp.point];
    }
    maxIndex = self.toucharray.count;

    return self;
}

- (id)initWithImage:(NSString *)image andPosition:(CGPoint)sPosition
{
    self.imageString = image;
    self.startingPosition = NSStringFromCGPoint(sPosition);
    self.startingCGPosition = sPosition;
    return [self initFromDatabase];
}

-(void) resetPath
{
    [self.toucharray removeAllObjects];
    currentIndex = 0;
}

-(void) moveSpriteWithSpeed:(int)pSpeed
{
    speed = pSpeed;
    currentIndex = currentIndex + 2;
    if( currentIndex > self.toucharray.count ) {
        // Don't do anything no path.
        [self spriteMoveFinished:self];
        return;
    } else if( currentIndex >= self.maxIndex ) {
        // Ignore last entry in path.
        [self spriteMoveFinished:self];
        return;
    }
    CGPoint newPoint = CGPointFromString([self.toucharray objectAtIndex:currentIndex]);
    float distance = ccpDistance(self.sprite.position, newPoint);
    float duration = distance / speed;
    
    id actionMove = [CCMoveTo actionWithDuration:duration position:newPoint ];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    
    [self.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)spriteMoveFinished:(id)sender {
    if( currentIndex < self.maxIndex) {
        [self moveSpriteWithSpeed:speed];
    } else {
        // Done moving.
    }
}

-(void) resetSprite
{
    self.sprite.position = self.startingCGPosition;
    currentIndex = 0;
}

-(void) repositionSpriteWithPosition:(CGPoint)pPosition
{
    self.startingCGPosition = pPosition;
    self.startingPosition = NSStringFromCGPoint( pPosition);
    self.sprite.position = self.startingCGPosition;
    currentIndex = 0;
}

-(void) saveSpritePoints
{
    // First delete the existing spritePoints
    for( SpritePoint *sp in self.spritePoints ) {
        [self.managedObjectContext deleteObject:sp];
    }
    
    int index = 0;
    for( NSString *cgp in self.toucharray ) {
        SpritePoint *sp1 = [NSEntityDescription insertNewObjectForEntityForName:@"SpritePoint" inManagedObjectContext:self.managedObjectContext];
        sp1.order = [NSNumber numberWithInt:index];
        sp1.point = cgp;
        sp1.parentSprite = self;
        index++;
    }
}


@end
