//
//  Playbook.h
//  PlayField
//
//  Created by Jai Lebo on 3/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlaybookPlay;

@interface Playbook : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *order;

@property (nonatomic, retain) PlaybookPlay *playbookPlay;

@end
