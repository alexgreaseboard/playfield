//
//  SpritePoint.h
//  PlayField
//
//  Created by Jai Lebo on 2/23/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PlaySprite.h"

@class PlaySprite;

@interface SpritePoint : NSManagedObject

@property (nonatomic, retain) NSNumber *order;
@property (nonatomic, retain) NSString *point;
@property (nonatomic, retain) PlaySprite *parentSprite;

@end
