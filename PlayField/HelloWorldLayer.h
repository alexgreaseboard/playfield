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
#import "Play.h"
#import "PlayCreationItemsTableViewController.h"

@interface HelloWorldLayer : CCLayer <PlayCreationItemsDelegate>

@property (strong, nonatomic) Play *play;
@property (nonatomic, strong) NSMutableOrderedSet *movableSprites;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

+(CCScene *) scene;
- (id) init;
- (void) setCurrentPlay:(Play *)pPlay;
- (void) addItemSprite:(NSString *)itemName;

@end
