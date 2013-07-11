//
//  GameTime.h
//  greaseboard
//
//  Created by Emily Jeppson on 7/10/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Playbook;

@interface GameTime : NSManagedObject

@property (nonatomic, retain) NSNumber * homeScore;
@property (nonatomic, retain) NSNumber * awayScore;
@property (nonatomic, retain) NSNumber * homeTimeouts;
@property (nonatomic, retain) NSNumber * awayTimeouts;
@property (nonatomic, retain) Playbook *upcomingPlaybook;
@property (nonatomic, retain) Playbook *currentPlaybook;

@end
