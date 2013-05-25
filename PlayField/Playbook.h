//
//  Playbook.h
//  PlayField
//
//  Created by Jai Lebo on 5/25/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Playbook : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSManagedObject *playbookplay;
@property (nonatomic, retain) NSNumber *displayOrder;

@end
