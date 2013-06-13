//
//  PlayCreationRosterTableViewController.m
//  GreaseBoard
//
//  Created by Jai on 2/7/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import "PlayCreationPlaysTableViewController.h"
#import "AppDelegate.h"
#import "PlayCell.h"
#import "CocosViewController.h"

@interface PlayCreationPlaysTableViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PlayCreationPlaysTableViewController{
    bool isReadOnly;
    bool isReordering;
    CocosViewController *detailViewController;
    UIBarButtonItem *reorderButton;
    UIPanGestureRecognizer *panning;
}

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
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationPlaysTable - viewDidLoad"]];
                                
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(returnToMenu:) ];
    self.navigationItem.leftBarButtonItem = menuButton;
    

    NSObject* o = [[self.splitViewController.viewControllers lastObject] topViewController];
    if([o isKindOfClass:[CocosViewController class]]){
        detailViewController = (CocosViewController *)o;
        isReadOnly = NO;
        // add reorder button - only for Plays & Drills page
        NSMutableArray *allButtons = [[NSMutableArray alloc] initWithArray:self.navigationItem.rightBarButtonItems];
        reorderButton = [[UIBarButtonItem alloc] initWithTitle:@"Reorder" style:UIBarButtonItemStylePlain target:self action:@selector(startReorder:) ];
        [allButtons addObject:reorderButton];
        self.navigationItem.rightBarButtonItems = allButtons;
    } else {
        isReadOnly = YES;
        self.tableView.allowsSelection = NO;
        self.editing = NO;
        self.tableView.editing = NO;
        self.delegate = (id<PlayCreationPlaysDelegate>)o;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    isReordering = NO;
    
    // gesture recognizer for drag & drop
    panning = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanning:)];
    panning.minimumNumberOfTouches = 1;
    panning.maximumNumberOfTouches = 1;
    panning.delegate = self;
    [self.tableView addGestureRecognizer:panning];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertNewPlay:(id)sender
{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationPlaysTable - insertNewPlay"]];
    Play *newPlay = [NSEntityDescription insertNewObjectForEntityForName:@"Play" inManagedObjectContext:self.managedObjectContext];
    
    NSString *tabTitle = self.tabBarItem.title;
    newPlay.name = [@"New " stringByAppendingString:tabTitle];
    newPlay.type = tabTitle;
    newPlay.runPass = @"Pass";
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (PlayCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreationPlayCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationPlaysTable - selected play at index %d", indexPath.item]];
    Play *play = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [detailViewController setCurrentPlay:play];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return(!isReadOnly);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationPlaysTable - deleting play at index %d", indexPath.item]];
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            [self fatalCoreDataError:error];
            return;
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationPlaysTable - Move row at index path from %i to %i", fromIndexPath.item, toIndexPath.item]];
    NSMutableArray *allPlays = [self.fetchedResultsController.fetchedObjects mutableCopy];
    Play *playToMove = [self.fetchedResultsController objectAtIndexPath:fromIndexPath];
    [allPlays removeObject:playToMove];
    [allPlays insertObject:playToMove atIndex:toIndexPath.item];
    for(int i=0; i<allPlays.count; i++){
        Play *currentPlay = allPlays[i];
        currentPlay.order = [[NSNumber alloc] initWithInt:i];
        //NSLog(@"Setting Order %@ for %@", currentPlay.order, currentPlay.name);
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Play" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString *playType = self.title;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(type = nil) or (type = %@)", playType];
    [fetchRequest setPredicate:predicate];
    
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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

- (void)configureCell:(PlayCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = [[object valueForKey:@"name"] description];
    
    //cell.nameLabel.textColor = [UIColor greenColor];
    //cell.nameLabel.backgroundColor = [UIColor yellowColor];
    //cell.nameLabel.opaque = NO;
    //cell.backgroundColor = [UIColor blackColor];
}

- (void) fatalCoreDataError:(NSError *)error
{
    NSLog(@"*** Fatal error in %s:%d\n%@\n%@", __FILE__, __LINE__, error, [error userInfo]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internal Error", nil) message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)theAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    abort();
}

- (IBAction)returnToMenu:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToMenu];
}

- (IBAction)startReorder:(id)sender{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationPlaysTable - start reorder"]];
    if(isReordering == NO){
        isReordering = YES;
        [self setEditing:YES animated:YES];
        reorderButton.title = @"Done Reordering";
    } else {
        // Save everything
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // reload
        [self.tableView reloadData];
        [self setEditing:NO animated:YES];
        reorderButton.title = @"Reorder";
        isReordering = NO;
    }
}

#pragma UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    // only recognize the drag & drop for horizontal dragging - it interferes with reordering
    CGPoint translation = [panning translationInView:self.view];
    return fabs(translation.x) > fabs(translation.y);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

- (void)handlePanning:(UIPanGestureRecognizer *)sender {
    
    if(sender.state == UIGestureRecognizerStateBegan){
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationPlaysTable - dragging started"]];
        //NSLog(@"Dragging started");
        CGPoint p1 = [sender locationOfTouch:0 inView:self.tableView];
        NSIndexPath *newPinchedIndexPath1 = [self.tableView indexPathForRowAtPoint:p1];
        Play *selectedPlay = [self.fetchedResultsController objectAtIndexPath:newPinchedIndexPath1];
        [self.delegate draggingStarted:sender forPlay:selectedPlay];
    } else if(sender.state == UIGestureRecognizerStateChanged){
        [self.delegate draggingChanged:sender];
        //NSLog(@"Dragging..");
    } else if(sender.state == UIGestureRecognizerStateEnded){
        [self.delegate draggingEnded:sender];
        //NSLog(@"Dragging stopped");
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationPlaysTable - dragging stopped"]];
    }
    
}

@end
