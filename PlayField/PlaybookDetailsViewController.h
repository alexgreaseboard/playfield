//
//  PlaybookDetailsViewController.h
//  PlayField
//
//  Created by Jai Lebo on 3/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbook.h"

@interface PlaybookDetailsViewController : UIViewController <UIAlertViewDelegate,NSFetchedResultsControllerDelegate>

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)addPlaybook:(id)sender;

@end
