//
//  PlayBookMasterViewController.h
//  PlayField
//
//  Created by Jai Lebo on 3/6/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PlaybookDetailsViewController.h"

@interface PlayBookMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) PlaybookDetailsViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
