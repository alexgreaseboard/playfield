//
//  PlaysDataSource.h
//  PlayField
//
//  Created by Emily Jeppson on 5/2/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbook.h"

@interface PlaybookPlayDataSource :  NSObject<NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *offenseOrDefense;
@property (strong, nonatomic) Playbook *playbook;

-(id) initWithManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;

@end
