//
//  PlayCreationRosterTableViewController.h
//  GreaseBoard
//
//  Created by Jai on 2/7/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

// Drag & drop
@protocol PlayCreationPlaysDelegate
- (void)draggingStarted:(UIPanGestureRecognizer *)sender forPlayWithName:(NSString *)name;
- (void)draggingChanged:(UIPanGestureRecognizer *)sender;
- (void)draggingEnded:(UIPanGestureRecognizer *)sender;
@end

@interface PlayCreationPlaysTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) id<PlayCreationPlaysDelegate> delegate;

- (IBAction)insertNewPlay:(id)sender;

@end
