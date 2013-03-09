//
//  HelloWorldLayer.h
//  PlayField
//
//  Created by Jai on 2/11/13.
//  Copyright Jai 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "PlaySprite.h"
#import "CocosViewController.h"
#import "Play.h"

@interface HelloWorldLayer : CCLayer

@property (strong, nonatomic) Play *play;
@property (nonatomic, strong) NSMutableOrderedSet *movableSprites;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

+(CCScene *) sceneWithCocosViewController:(CocosViewController *)pCocosViewController;
- (id) initWithCocosViewController:(CocosViewController *)pCocosViewController;
- (void) setCurrentPlay:(Play *)pPlay;
- (void) addItemSprite:(NSString *)itemName;

@end
