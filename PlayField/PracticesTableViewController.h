//
//  PracticesTableViewController.h
//  PlayField
//
//  Created by Emily Jeppson on 3/9/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeViewController.h"
#import "PracticeEditViewController.h"

@interface PracticesTableViewController : UITableViewController <PracticeEditControllerDelegate, NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) PracticeViewController *practiceViewController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
