//
//  HelloWorldLayer.m
//  PlayField
//
//  Created by Jai on 2/11/13.
//  Copyright Jai 2013. All rights reserved.
//


#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "PlaySprite.h"
#import "SpritePoint.h"

#pragma mark - HelloWorldLayer

@implementation HelloWorldLayer
{
    bool positioning;
    PlaySprite *selPlayerSprite;
    CocosViewController *cocosViewController;
    CCMenuItem *trashMenuItem;
    //CCSprite *background;
}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) sceneWithCocosViewController:(CocosViewController *)pCocosViewController
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [[HelloWorldLayer alloc] initWithCocosViewController:pCocosViewController];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) initWithCocosViewController:(CocosViewController *)pCocosViewController
{
	if( (self=[super init] )) {
        //CGSize winSize = [CCDirector sharedDirector].winSize;
        glClearColor(0, 255, 0, 255);
        // Set Background
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        //background = [CCSprite spriteWithFile:@"football-field.jpg"];
        //background.anchorPoint = ccp(0,0);
        //[self addChild:background z:-1];
        //[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        
        // Standard method to create a button
        CCMenuItem *playMenuItem = [CCMenuItemImage itemWithNormalImage:@"playButton.png" selectedImage:@"playButton.png" target:self selector:@selector(playButtonTapped:)];
        CCMenuItem *resetMenuItem = [CCMenuItemImage itemWithNormalImage:@"resetButton.png" selectedImage:@"resetButton.png" target:self selector:@selector(resetButtonTapped:)];
        CCMenuItem *positionMenuItem = [CCMenuItemImage itemWithNormalImage:@"positionButton.png" selectedImage:@"positionButton.png" target:self selector:@selector(positionButtonTapped:)];
        trashMenuItem = [CCMenuItemImage itemWithNormalImage:@"trashButton.png" selectedImage:@"trashButton.png" target:self selector:@selector(trashButtonTapped:)];
        playMenuItem.position = ccp(60, 60);
        resetMenuItem.position = ccp(110,60);
        positionMenuItem.position = ccp(160,60);
        trashMenuItem.position = ccp(640,60);
        CCMenu *starMenu = [CCMenu menuWithItems:playMenuItem, resetMenuItem, positionMenuItem, trashMenuItem, nil];
        //starMenu.position = CGPointZero;
        starMenu.position = ccp(0,15);
        [self addChild:starMenu];
        
        self.movableSprites = [[NSMutableOrderedSet alloc] init];
        cocosViewController = pCocosViewController;
        positioning = false;
    }
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    PlaySprite *newPlayerSprite = nil;
    for (PlaySprite *ps in self.movableSprites) {
        if (CGRectContainsPoint(ps.sprite.boundingBox, touchLocation)) {
            newPlayerSprite = ps;
            break;
        }
    }

    selPlayerSprite = newPlayerSprite;
        
    //remove objects each time the player makes a new path
    [selPlayerSprite resetPath];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    if(!positioning) {
        [self resetScene];
    }
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint newTouchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    if(!positioning) {
        // add touches to the touch array
        //SpritePoint *sp1 = [NSEntityDescription insertNewObjectForEntityForName:@"SpritePoint" inManagedObjectContext:self.managedObjectContext];
        //sp1.point = NSStringFromCGPoint(newTouchLocation);
        //sp1.playSprite = selPlayerSprite;
        //SpritePoint *sp2 = [NSEntityDescription insertNewObjectForEntityForName:@"SpritePoint" inManagedObjectContext:self.managedObjectContext];
        //sp2.point = NSStringFromCGPoint(oldTouchLocation);
        //sp2.playSprite = selPlayerSprite;
        [selPlayerSprite.toucharray addObject:NSStringFromCGPoint(newTouchLocation)];
        [selPlayerSprite.toucharray addObject:NSStringFromCGPoint(oldTouchLocation)];
    }
    
    CGPoint translation = ccpSub(newTouchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(positioning) {
        CGPoint newPosition = [self convertTouchToNodeSpace:touch];
        [selPlayerSprite repositionSpriteWithPosition:newPosition ];
        
        if (CGRectIntersectsRect(selPlayerSprite.sprite.boundingBox, trashMenuItem.boundingBox)) {
            [self removePlaySprite:selPlayerSprite];
        }
        
    } else {
        // Move Sprint to beginning of line
        if( [selPlayerSprite.toucharray count] > 0 ) {
            CGPoint origPosition = CGPointFromString( [selPlayerSprite.toucharray objectAtIndex:0] );
            selPlayerSprite.sprite.position = origPosition;
            selPlayerSprite.maxIndex = [selPlayerSprite.toucharray count];
        }
    }
}

- (void)panForTranslation:(CGPoint)translation {
    if (selPlayerSprite) {
        CGPoint newPos = ccpAdd(selPlayerSprite.sprite.position, translation);
        selPlayerSprite.sprite.position = newPos;
    }
}

- (void)draw {
    glLineWidth(3.0f);
    //glColor3f(1.0,1.0,1.0);
    
    for (PlaySprite *ps in self.movableSprites) {
        for (int i = 0; i < [ps.toucharray count]; i+=2) {
            CGPoint start = CGPointFromString([ps.toucharray objectAtIndex:i]);
            CGPoint end = CGPointFromString([ps.toucharray objectAtIndex:i+1]);
            ccDrawLine(start, end);
        }
    }
}

- (void) resetScene{
    for(PlaySprite *ps in self.movableSprites) {
        [ps.sprite stopAllActions];
        [ps resetSprite];
    }
}

- (void)playButtonTapped:(id)sender {
    for (PlaySprite *ps in self.movableSprites) {
        [ps moveSpriteWithSpeed:100];
    }
}

- (void)resetButtonTapped:(id)sender {
    for (PlaySprite *ps in self.movableSprites) {
        [ps resetSprite];
    }
}

- (void)trashButtonTapped:(id)sender {
}

- (void)positionButtonTapped:(id)sender {
    if( positioning ) {
        for(PlaySprite *ps in self.movableSprites) {
            [ps.sprite stopAllActions];
            [ps.sprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        }
    } else {
        [self resetScene];
        for(PlaySprite *ps in self.movableSprites) {
            [self actionSpriteForPositioning:ps.sprite];
        }
    }
    positioning = !positioning;
}

- (void) actionSpriteForPositioning:(CCSprite *)pSprite
{
    CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-12.0];
    CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
    CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:12.0];
    CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
    [pSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
}

- (void) addDefaultPlay
{
    // Offense
    int centerH = 350;
    int centerV = 300;
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH,centerV)];    // Center
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH+50,centerV)];
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH+100,centerV)];
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH-50,centerV)];
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH-100,centerV)];
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH-150,centerV)];
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH,centerV-40)]; // Quarterback
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH,centerV-100)];
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH-50,centerV-100)];
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH+175,centerV-60)];
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH+250,centerV)];
    
    // Defense
    centerH = 350;
    centerV = 350;
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH,centerV)];    
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH+100,centerV)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH+165,centerV)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH-100,centerV)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH-150,centerV)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH-50,centerV+50)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH+50,centerV+50)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH+200,centerV+50)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH+275,centerV+50)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH-200,centerV+75)];
    [self addPlayerSpriteWithImage:@"Sad.png" andPosition:ccp(centerH,centerV+175)];
}

- (void) addDefaultDrill
{
    // Offense
    int centerH = 350;
    int centerV = 300;
    [self addPlayerSpriteWithImage:@"Smile.png" andPosition:ccp(centerH,centerV)];    // Player
    [self addPlayerSpriteWithImage:@"cone.jpeg" andPosition:ccp(centerH,centerV + 100)];    // Cone
}

- (void) addPlayerSpriteWithImage:(NSString *)pImage andPosition:(CGPoint)pPosition {
    PlaySprite *ps = [NSEntityDescription insertNewObjectForEntityForName:@"PlaySprite" inManagedObjectContext:self.managedObjectContext];
    ps = [ps initWithImage:pImage andPosition:pPosition];
    ps.play = self.play;
    [self addChild: ps.sprite ];
    [self.movableSprites addObject:ps];
    if(positioning) {
        [self actionSpriteForPositioning:ps.sprite];
    }
}

- (void) loadPlaySprites
{
    for(PlaySprite *ps in self.play.playSprite) {
        [self loadPlaySprite:ps];
    }
}

- (void) loadPlaySprite:(PlaySprite *)pPlaySprite {
    pPlaySprite = [pPlaySprite initFromDatabase];
    [self addChild:pPlaySprite.sprite];
    [self.movableSprites addObject:pPlaySprite];
}

- (void) removePlaySprite:(PlaySprite *)pPlaySprite {
    [self removeChild:pPlaySprite.sprite];
    [self.movableSprites removeObject:pPlaySprite];
    [self.managedObjectContext deleteObject:pPlaySprite];
}

- (void) setCurrentPlay:(Play *)pPlay {

    for(PlaySprite *ps in self.movableSprites) {
        [self removeChild:ps.sprite];
    }
    [self.movableSprites removeAllObjects];
    
    self.play = pPlay;
    if( [self.play.playSprite count] == 0 ) {
        // Add default play.
        if( [self.play.type isEqualToString:@"Drill"] ) {
            [self addDefaultDrill];
        } else {
            [self addDefaultPlay ];
        }
    } else {
        [self loadPlaySprites];
    }
}

- (void) addItemSprite:(NSString *)itemName
{
    [self addPlayerSpriteWithImage:itemName andPosition:ccp(350,75)];
}

@end
