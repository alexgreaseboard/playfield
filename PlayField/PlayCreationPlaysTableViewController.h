//
//  PlayCreationRosterTableViewController.h
//  GreaseBoard
//
//  Created by Jai on 2/7/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CocosViewController.h"

@interface PlayCreationPlaysTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) CocosViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)insertNewPlay:(id)sender;

@end
