//
//  MasterViewController.h
//  GreaseBoard
//
//  Created by Jai Lebo on 1/28/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RosterDetailViewController.h"

@class RosterDetailViewController;

#import <CoreData/CoreData.h>

@interface RosterMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,RosterDetailViewControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) RosterDetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)returnToMenu:(id)sender;

@end
