//
//  PlaysDataSource.m
//  PlayField
//
//  Created by Emily Jeppson on 5/2/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookPlayDataSource.h"
#import "PlaybookPlayCell.h"
#import "PlaybookPlay.h"

@implementation PlaybookPlayDataSource


-(id) initWithManagedObjectContext: (NSManagedObjectContext*) managedObjectContext{
    if((self=[super init])){
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    //NSLog(@"Number of items in section %d", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [[self.fetchedResultsController sections] count];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PlaybookPlayCell" forIndexPath:indexPath];
    
    PlaybookPlayCell *playbookCell = (PlaybookPlayCell *) cell;
    PlaybookPlay *playbookPlay = [self.fetchedResultsController objectAtIndexPath:indexPath];
    playbookCell = [playbookCell initWithFrame:playbookCell.frame playbookPlay:playbookPlay];
    if([playbookPlay.status isEqualToString:@"Dragging"]){
        [playbookCell highlightCell];
    } else {
        [playbookCell unhighlightCell];
    }
    return playbookCell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(150, 150);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark – Database

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlaybookPlay" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Predicates
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookPlayDS - fetching type: %@, playbook: %@", self.offenseOrDefense, self.playbook.name]];
    if(self.offenseOrDefense && self.playbook){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"(play.type == %@) && (playbook == %@) && playbook != nil", self.offenseOrDefense, self.playbook];
        [fetchRequest setPredicate:predicate];
    } else if (self.playbook){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"(playbook == %@)", self.playbook];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"(playbook == nil)", self.playbook];
        [fetchRequest setPredicate:predicate];
    }
     
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"play.name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    NSLog(@"Count: %i", [aFetchedResultsController.fetchedObjects count]);
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    [self fatalCoreDataError:error];
	}
    
    return _fetchedResultsController;
}

- (void) fatalCoreDataError:(NSError *)error
{
    NSLog(@"*** Fatal error in %s:%d\n%@\n%@", __FILE__, __LINE__, error, [error userInfo]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internal Error", nil) message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

#pragma UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// Reorder plays
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
   [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookPlayDataSource - Reordering plays..."]];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];
    id object = [mutableArray objectAtIndex:fromIndexPath.item];
    [mutableArray removeObjectAtIndex:fromIndexPath.item];
    [mutableArray insertObject:object atIndex:toIndexPath.item];
    
    for(int i=0; i<mutableArray.count; i++){
        PlaybookPlay *playbookPlay = (PlaybookPlay*)mutableArray[i];
        playbookPlay.displayOrder = [NSNumber numberWithInt:i];
    }
    // save the new order
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        [self fatalCoreDataError:error];
        return;
    }
}
@end
