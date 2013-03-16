//
//  PlaybookDetailsViewController.h
//  PlayField
//
//  Created by Jai Lebo on 3/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbook.h"

@interface PlaybookViewController : UIViewController <UIAlertViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (IBAction)addPlaybook:(id)sender;

@end
