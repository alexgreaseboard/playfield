//
//  PracticesTableViewController.m
//  PlayField
//
//  Created by Emily Jeppson on 3/9/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PracticesTableViewController.h"
#import "Practice.h"
#import "AppDelegate.h"
#import "PracticeCell.h"
#import "PracticeEditViewController.h"

@interface PracticesTableViewController ()

@end

@implementation PracticesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeTable - loading"]];

    // add the two buttons
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(returnToMenu:) ];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPracticeScreen:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // get the app context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.practiceViewController = (PracticeViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    if([self tableView:self.tableView numberOfRowsInSection:0]> 0 && self.practiceViewController.practice == nil){
        NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:index];
        [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PracticeCell";
    PracticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // get the practice
    Practice *practice = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.practiceLabel.text = practice.practiceName;
    cell.durationLabel.text = [NSString stringWithFormat:@"%@ minutes", practice.practiceDuration];
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeTable - deleting practice"]];
        // Delete the row from the data source
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][indexPath.section];
        [[sectionInfo objects] objectAtIndex:indexPath.item];
        NSManagedObject *selectedObject = [[sectionInfo objects] objectAtIndex:indexPath.item];
        [self.managedObjectContext deleteObject:selectedObject];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.practiceViewController resetViewWithPractice:nil];
    }  
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeTable - selected practice"]];
    Practice *practice = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.practiceViewController resetViewWithPractice:practice];
}

-(void)showPracticeScreen:(id)sender{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeTable - practice edit"]];
    [self performSegueWithIdentifier:@"showPracticeEdit" sender:sender];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPracticeEdit"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PracticeEditViewController *practiceEdit = (PracticeEditViewController *)navigationController.topViewController;
        practiceEdit.delegate = self;
        practiceEdit.practice = [NSEntityDescription insertNewObjectForEntityForName:@"Practice" inManagedObjectContext:self.managedObjectContext];
        
    }
}

#pragma mark - PracticeEditController
- (void)practiceEditController:(PracticeEditViewController *)controller didFinishAddingPractice:(Practice *)practice{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeTable - done adding practice"]];
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    // select the practice that was just added
    
    [self.tableView reloadData];
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    int index = [[sectionInfo objects] indexOfObject:practice];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    //NSLog(@"Index: %@", indexPath);
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
     [self dismissViewControllerAnimated:YES completion:nil];
     
}

- (void)practiceEditController:(PracticeEditViewController *)controller didCancelAddingPractice:(Practice *)practice{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeTable - cancel adding practice"]];
    // Save the context.
    [self.managedObjectContext deleteObject:practice];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)returnToMenu:(id)sender
{
    //NSLog(@"Returning to menu");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToMenu];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Practice" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"practiceName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
