//
//  PlaybookDataSourceViewController.h
//  PlayField
//
//  Created by Emily Jeppson on 5/1/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "CocosViewController.h"

@interface PlaybookDataSource : NSObject<NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(id) initWithManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;
@end
