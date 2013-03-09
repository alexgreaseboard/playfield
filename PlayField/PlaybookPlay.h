//
//  PlaybookPlay.h
//  PlayField
//
//  Created by Jai Lebo on 3/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Play, Playbook;

@interface PlaybookPlay : NSManagedObject

@property (nonatomic, retain) Playbook *playbook;
@property (nonatomic, retain) Play *play;

@end
