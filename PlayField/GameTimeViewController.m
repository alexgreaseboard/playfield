//
//  GameTimeViewController.m
//  PlayField
//
//  Created by Emily Jeppson on 5/1/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "GameTimeViewController.h"
#import "AppDelegate.h"
#import "PinchLayout.h"
#import "PlaybookCell.h"
#import "PlaybookPlayCell.h"
#import "Playbook.h"
#import "GameTime.h"

@interface GameTimeViewController ()

@end

@implementation GameTimeViewController{
    UICollectionViewCell *draggingCell;
	PlaybookPlay *draggingPlaybookPlay;
    Playbook *draggingPlaybook;
    CGRect initialDraggingFrame;
    bool upcomingPlayRemoved;
    PlaybookPlay *selectedPlaybookplay;
    GameTime *gameTime; // there should always be 1 gametime for this page
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TestFlight passCheckpoint:@"Loading GameTime"];
	// Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field.jpg"]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [self.view convertRect:self.collectionLabel.frame toView:self.view];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    //[self.view.layer insertSublayer:gradient below:self.collectionLabel.layer];
    
    self.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    
    [self setupDataSources];
    [self setupGestures];
    
    // load the current game time object
    [self setupGametime];
    [self switchType:nil];
    
    //disable buttons
    [self enableButtons];
}

-(void) setupGametime{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GameTime" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // only get 1
    [fetchRequest setFetchBatchSize:1];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"homeScore" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    [aFetchedResultsController performFetch:&error];
    if([aFetchedResultsController.fetchedObjects count] > 0){
        gameTime = [aFetchedResultsController.fetchedObjects objectAtIndex:0];
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - found existing gametime %@", gameTime]];
    } else {
        [TestFlight passCheckpoint:@"GameTime - creating new game time object"];
        gameTime = [NSEntityDescription insertNewObjectForEntityForName:@"GameTime" inManagedObjectContext:self.managedObjectContext];
        gameTime.homeScore = 0;
        gameTime.awayScore = 0;
        gameTime.awayTimeouts = [NSNumber numberWithInt:3];
        gameTime.homeTimeouts = [NSNumber numberWithInt:3];
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) setupDataSources {
    // data
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.playBookDS = [[PlaybookDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.playbookPlayDS = [[PlaybookPlayDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.upcomingPlaysDS = [[PlaybookPlayDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    // set the datasources/delegates
    self.playbooksCollection.dataSource = self.playBookDS;
    self.playbooksCollection.delegate = self;
    self.upcomingPlaysCollection.dataSource = self.upcomingPlaysDS;
    self.upcomingPlaysCollection.delegate = self;
    
    [self.playbooksCollection registerClass:[PlaybookCell class] forCellWithReuseIdentifier:@"PlaybookCell"];
    [self.upcomingPlaysCollection registerClass:[PlaybookPlayCell class] forCellWithReuseIdentifier:@"PlaybookPlayCell"];
}

- (void) setupGestures{
    // gestures = drag & drop playbooks
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlaybookPanning:)];
    panRecognizer.delegate = self;
    [self.playbooksCollection addGestureRecognizer:panRecognizer];
    // gestures - drag & drop upcoming plays
    UIPanGestureRecognizer *upcomingPlaysGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpcomingPlaysPanning:)];
    upcomingPlaysGestureRecognizer.delegate = self;
    [self.upcomingPlaysCollection addGestureRecognizer:upcomingPlaysGestureRecognizer];
    
    // gestures - tap the current play
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCurrentPlayTap:)];
    [self.currentPlayView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


// drag & drop for plays to upcoming plays
- (void)handlePlayPanning:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // get the pinch point in the play books collection
        CGPoint pinchPoint = [recognizer locationInView:self.playsCollection];
        NSIndexPath *pannedItem = [self.playsCollection indexPathForItemAtPoint:pinchPoint];
        if (pannedItem) {
            [TestFlight passCheckpoint:@"GameTime - started dragging a play"];
            self.currentPannedItem = pannedItem;

            initialDraggingFrame.origin = pinchPoint;
            initialDraggingFrame.size.height = 150;
            initialDraggingFrame.size.width = 150;
            // center the cell
            initialDraggingFrame.origin.x -= (initialDraggingFrame.size.width / 2);
            initialDraggingFrame.origin.y -= (8 + self.playsCollection.contentOffset.y);
            // have we scrolled?
//            initialDraggingFrame.origin.y -= [self.playsCollection contentOffset].y;
            initialDraggingFrame.origin.y += (initialDraggingFrame.size.height);
            
            // add the cell to the view
            draggingPlaybookPlay = [self.playbookPlayDS.fetchedResultsController objectAtIndexPath:pannedItem];
            draggingPlaybookPlay = [self createDraggingPlaybook:draggingPlaybookPlay];
            draggingPlaybookPlay.status = @"Dragging";
            draggingCell = [[PlaybookPlayCell alloc] initWithFrame:initialDraggingFrame playbookPlay:draggingPlaybookPlay];
            [((PlaybookPlayCell*) draggingCell) highlightCell];
            [self.view addSubview:draggingCell];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if(self.currentPannedItem == nil || draggingPlaybookPlay == nil){
            return;
        }
        // move the cell around
        CGPoint translation = [recognizer translationInView:self.playsCollection];
        CGRect newFrame = initialDraggingFrame;
        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;
        draggingCell.frame = newFrame;
        //draggingPlaybookPlay.status = @"Dragging";
        //move the placeholder
        [self addDraggedCell:recognizer draggedItem:draggingPlaybookPlay];
    } else {
        if(self.currentPannedItem == nil || draggingPlaybookPlay == nil){
            return;
        }
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - finished dragging play - %@", draggingPlaybookPlay.play]];
        //NSLog(@"dragging ended");
        // add the cell to the appropriate place
        draggingPlaybookPlay.status = nil;
        [self addDraggedCell:recognizer draggedItem:draggingPlaybookPlay];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self cleanupPlaybooks];
        [draggingCell removeFromSuperview];
        draggingCell = nil;
        draggingPlaybookPlay = nil;
        [self enableButtons];
    }
}

- (PlaybookPlay*) createDraggingPlaybook:(PlaybookPlay*)draggedItem{
    // if this is the first item being added to upcoming plays, create a playbook and save it to game time
    
    Playbook *upcomingPlaybook = gameTime.upcomingPlaybook;
    if(!upcomingPlaybook){
        upcomingPlaybook = [NSEntityDescription insertNewObjectForEntityForName:@"Playbook" inManagedObjectContext:self.managedObjectContext];
        upcomingPlaybook.type = @"hidden";
        upcomingPlaybook.name = @"Upcoming Plays";
        gameTime.upcomingPlaybook = upcomingPlaybook;
    }
    if(draggedItem.playbook != gameTime.upcomingPlaybook){
        Play *play = draggedItem.play;
        draggedItem = [NSEntityDescription insertNewObjectForEntityForName:@"PlaybookPlay" inManagedObjectContext:self.managedObjectContext];
        draggedItem.playbook = gameTime.upcomingPlaybook;
        draggedItem.play = play;
    }
    //draggedItem.status = @"Dragging";
    self.upcomingPlaysDS.playbook = upcomingPlaybook;
    [self.upcomingPlaysCollection reloadData];
    return draggedItem;
}

- (void) cleanupPlaybooks{
    self.upcomingPlaysDS.playbook = gameTime.upcomingPlaybook;
    id <NSFetchedResultsSectionInfo> section = self.upcomingPlaysDS.fetchedResultsController.sections[0];
    //if([draggingPlaybook.playbookplays count] > 0){
        for(PlaybookPlay *playbookPlay in [section objects]){
            if(playbookPlay.displayOrder == nil){
                [self.managedObjectContext deleteObject:playbookPlay];
            }
        }
    for(int i=0; i<self.upcomingPlaysDS.fetchedResultsController.fetchedObjects.count; i++){
        PlaybookPlay *pp = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:i];
        pp.displayOrder = [NSNumber numberWithInt:i];
    }
    //}
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)addDraggedCell:(UIPanGestureRecognizer*)sender draggedItem:(PlaybookPlay*) draggedItem {
        // add the cell to the appropriate place
        CGPoint translation = [sender translationInView:self.upcomingPlaysCollection];
        CGRect newFrame = initialDraggingFrame;
        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;
        newFrame.origin.x += self.upcomingPlaysCollection.contentOffset.x;
        NSIndexPath *landingPoint = [self.upcomingPlaysCollection indexPathForItemAtPoint:newFrame.origin];
    
        if(landingPoint){
            
            //Play *landingItem = self.upcomingPlaysDS.upcomingPlays[landingPoint.item];
            int index = landingPoint.item;
            if(index > 0){
                index--;
            }
            
            
            NSLog(@"New index %i", index);
            if(draggedItem.displayOrder.intValue != index){
            for( int i=[self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count]-1; i>=0; i--){
                PlaybookPlay *pp = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:i];
                if(pp != draggedItem){
                    if(i >= index){
                        NSLog(@"Changing from %i to %i", i, (i+1));
                        pp.displayOrder = [NSNumber numberWithInt:(i+1)];
                    } else {
                        pp.displayOrder = [NSNumber numberWithInt:i];
                    }
                }
            }
            }
            draggedItem.displayOrder = [NSNumber numberWithInt:index];
        } else if(newFrame.origin.x > 0 && newFrame.origin.y > 0 && newFrame.origin.x < self.upcomingPlaysCollection.frame.
            size.width && newFrame.origin.y < self.upcomingPlaysCollection.frame.size.height){
            NSLog(@"Adding to end");
            draggedItem.displayOrder = [NSNumber numberWithInt:[self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count] ];
        } else {
            //NSLog(@"Not dragging over upcoming plays %f %f", newFrame.origin.x, newFrame.origin.y);
        }
    // save & reload
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.upcomingPlaysCollection reloadData];
        
}

// drag & drop for playbooks to upcoming plays
- (void)handlePlaybookPanning:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - started dragging playbook"]];
        // get the pinch point in the play books collection
        CGPoint pinchPoint = [recognizer locationInView:self.playbooksCollection];
        NSIndexPath *pannedItem = [self.playbooksCollection indexPathForItemAtPoint:pinchPoint];
        if (pannedItem) {
            self.currentPannedItem = pannedItem;
            
            initialDraggingFrame.origin = pinchPoint;
            initialDraggingFrame.size.height = 150;
            initialDraggingFrame.size.width = 150;
            // center the cell
            initialDraggingFrame.origin.x -= (initialDraggingFrame.size.width / 2);
            initialDraggingFrame.origin.y -= (8 + self.playsCollection.contentOffset.y);
            // have we scrolled?
            initialDraggingFrame.origin.y -= [self.playbooksCollection contentOffset].y;
            initialDraggingFrame.origin.y += (initialDraggingFrame.size.height);
            
            // add the cell to the view
            draggingPlaybook = [self.playBookDS.fetchedResultsController objectAtIndexPath:pannedItem];
            draggingCell = [[PlaybookCell alloc] initWithFrame:initialDraggingFrame playbook:draggingPlaybook];
            [self.view addSubview:draggingCell];
        }
    } else { // changed or ended
        if(self.currentPannedItem == nil || draggingPlaybook == nil){
            return;
        }
        //NSLog(@"Dragging changed");
        // move the cell around
        CGPoint translation = [recognizer translationInView:self.playbooksCollection];
        CGRect newFrame = initialDraggingFrame;
        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;
        draggingCell.frame = newFrame;
        //move the placeholder
        int previousCount = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count];
        self.playbookPlayDS.playbook = draggingPlaybook;
        id <NSFetchedResultsSectionInfo> section = self.playbookPlayDS.fetchedResultsController.sections[0];
        if([draggingPlaybook.playbookplays count] > 0){
            for(PlaybookPlay *playbookPlay in [section objects]){
                draggingPlaybookPlay = [self createDraggingPlaybook:draggingPlaybookPlay];
                [self addDraggedCell:recognizer draggedItem:playbookPlay];
            }
        }
        int afterCount = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count];
        if(afterCount > previousCount || recognizer.state == UIGestureRecognizerStateEnded){
            [draggingCell removeFromSuperview];
            draggingCell = nil;
            draggingPlaybook = nil;
            self.currentPannedItem = nil;
            
            [self enableButtons];
        }
        
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [self cleanupPlaybooks];
    }
    
}

// for removing plays from upcoming plays
- (void)handleUpcomingPlaysPanning:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // get the pinch point in the play books collection
        CGPoint pinchPoint = [recognizer locationInView:self.upcomingPlaysCollection];
        NSIndexPath *pannedItem = [self.upcomingPlaysCollection indexPathForItemAtPoint:pinchPoint];
        if (pannedItem) {
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - started dragging upcoming play"]];
            self.currentPannedItem = pannedItem;
            
            initialDraggingFrame.origin = pinchPoint;
            initialDraggingFrame.size.height = 150;
            initialDraggingFrame.size.width = 150;
            // center the cell
            initialDraggingFrame.origin.x += (75 + initialDraggingFrame.size.width);
            // have we scrolled?
            initialDraggingFrame.origin.x -= (self.upcomingPlaysCollection.contentOffset.x);
            //initialDraggingFrame.origin.y -= (self.upcomingPlaysCollection.contentOffset.y);
            initialDraggingFrame.origin.y -= (initialDraggingFrame.size.height / 2);
            
            // add the cell to the view
            
            draggingPlaybookPlay = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:pannedItem.item];
            draggingPlaybookPlay.status = @"Dragging";
            draggingCell = [[PlaybookPlayCell alloc] initWithFrame:initialDraggingFrame playbookPlay:draggingPlaybookPlay];
            [((PlaybookPlayCell*) draggingCell) highlightCell];
            [self.view addSubview:draggingCell];
            upcomingPlayRemoved = NO;
            //NSLog(@"Finding dragging play at index %d %@", pannedItem.item, draggingPlay);
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if(self.currentPannedItem == nil || draggingPlaybookPlay == nil){
            return;
        }
        //NSLog(@"Upcoming plays Dragging changed");
        // move the cell around
        CGPoint translation = [recognizer translationInView:self.upcomingPlaysCollection];
        CGRect newFrame = initialDraggingFrame;
        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;
        draggingCell.frame = newFrame;
        
        //remove it if needed
        CGPoint location = [recognizer locationInView:self.upcomingPlaysCollection];
        //NSLog(@"Location: %f Height: %f", location.y, self.upcomingPlaysCollection.frame.size.height);
        if(location.y > (self.upcomingPlaysCollection.frame.size.height + 10)){
            [self.managedObjectContext deleteObject:draggingPlaybookPlay];
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            [self.upcomingPlaysCollection reloadData];
            upcomingPlayRemoved = YES;
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - removed upcoming play %@", draggingPlaybookPlay]];
        }
        // reordering
        /*else if(location.y <= (self.upcomingPlaysCollection.frame.size.height)){
            // add it back if needed
            [self addDraggedCell:recognizer draggedItem:draggingPlaybookPlay];
            upcomingPlayRemoved = NO;
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - added upcoming play %@", draggingPlaybookPlay]];
        } */
    } else {
        if(self.currentPannedItem == nil || draggingPlaybookPlay == nil){
            return;
        }
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - finished dragging upcoming play %@", draggingPlaybookPlay]];
        [draggingCell removeFromSuperview];
        draggingCell = nil;
        draggingPlaybookPlay = nil;
        self.currentPannedItem = nil;
        [self enableButtons];
    }
}

#pragma UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma GameTimeViewController 
- (void) enableButtons{
    if([self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count] > 0){
        [self.nextPlayButton setEnabled: YES];
        [self.removeAllButton setEnabled: YES];
    } else {
        [self.nextPlayButton setEnabled: NO];
        [self.removeAllButton setEnabled: NO];
    }
}

- (IBAction)loadNextPlay:(id)sender {
    // get the first play from upcoming plays
    if([self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count] > 0){
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - load next play"]];
        PlaybookPlay *firstPlaybookPlay = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:0];
        
        CGRect frame = CGRectMake(self.currentPlayView.frame.origin.x + 2, self.currentPlayView.frame.origin.y, 150, 150);
        UICollectionViewCell *cell = [[PlaybookPlayCell alloc] initWithFrame:frame playbookPlay:firstPlaybookPlay];
        [self.currentPlayView addSubview:cell];
        self.currentPlay = firstPlaybookPlay;
        
        [self.managedObjectContext deleteObject:firstPlaybookPlay];
        for(PlaybookPlay *pp in self.upcomingPlaysDS.fetchedResultsController.fetchedObjects){
            pp.displayOrder = [NSNumber numberWithInt:pp.displayOrder.intValue - 1];
        }
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self.upcomingPlaysCollection reloadData];
        [self enableButtons];
    }
}

- (IBAction)removeAllPlays:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - remove all plays"]];
    for(PlaybookPlay *pp in self.upcomingPlaysDS.fetchedResultsController.fetchedObjects){
        [self.managedObjectContext deleteObject:pp];
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.upcomingPlaysCollection reloadData];
    [self enableButtons];
}

- (IBAction)switchType:(id)sender {
    NSString *newValue = @"Offense"; // default value
    NSLog(@"switch type");
    if(sender){
        UISegmentedControl *switchControl = (UISegmentedControl*)sender;
        newValue = [switchControl titleForSegmentAtIndex:switchControl.selectedSegmentIndex];
    }
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - switching type. Old type: %@", self.offenseOrDefense]];
    NSString *lbl = nil;
    NSString *upLabel = nil;
    self.offenseOrDefense = newValue;
    
    NSLog(@"new value %@", newValue);
    if([self.upcomingPlaysLabel.text rangeOfString:@"Offense"].location != NSNotFound){
        upLabel = [self.upcomingPlaysLabel.text stringByReplacingOccurrencesOfString:@"Offense" withString:newValue];
        lbl = [self.collectionLabel.text stringByReplacingOccurrencesOfString:@"Offense" withString:newValue];
    } else if([self.upcomingPlaysLabel.text rangeOfString:@"Defense"].location != NSNotFound){
        NSLog(@"Defense");
        lbl = [self.collectionLabel.text stringByReplacingOccurrencesOfString:@"Defense" withString:newValue];
        upLabel = [self.upcomingPlaysLabel.text stringByReplacingOccurrencesOfString:@"Defense" withString:newValue];
    } else {
        NSLog(@"Special");
        lbl = [self.collectionLabel.text stringByReplacingOccurrencesOfString:@"Special Teams" withString:newValue];
        upLabel = [self.upcomingPlaysLabel.text stringByReplacingOccurrencesOfString:@"Special Teams" withString:newValue];
    }
    [self.upcomingPlaysLabel setText:upLabel];
    [self.collectionLabel setText:lbl];
    
    self.upcomingPlaysDS.playbook = gameTime.upcomingPlaybook;
    self.playBookDS.offenseOrDefense = self.offenseOrDefense;
    self.playbookPlayDS.offenseOrDefense = self.offenseOrDefense;
    self.upcomingPlaysDS.offenseOrDefense = self.offenseOrDefense;
    [self.upcomingPlaysCollection reloadData];
    [self.playbooksCollection reloadData];
    [self.playsCollection reloadData];
}

- (IBAction)doneButtonPressed:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - done button"]];
    
    // animate
    CGRect newFrame = CGRectStandardize(self.playbooksCollection.frame);
    newFrame.origin.y += newFrame.size.height;
    [UIView animateWithDuration:.5 animations: ^{
        self.playsCollection.frame = newFrame;
        self.playbooksCollection.alpha = 1.0;
        self.doneButton.alpha = 0;
    }];
}


#pragma mark – UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - selected play"]];
    if(collectionView == self.upcomingPlaysCollection){
        selectedPlaybookplay = [self.upcomingPlaysDS.fetchedResultsController objectAtIndexPath:indexPath];
    } else if(collectionView == self.playsCollection){
        selectedPlaybookplay = [self.playbookPlayDS.fetchedResultsController objectAtIndexPath:indexPath];
    } else {
        
        Playbook *selectedPlaybook = [self.playBookDS.fetchedResultsController objectAtIndexPath:indexPath];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGRect newFrame = CGRectInset( self.playbooksCollection.frame, 0, 0);
        newFrame.origin.y += newFrame.size.height;
        self.playsCollection = [[UICollectionView alloc]
                                initWithFrame:newFrame collectionViewLayout:layout];
        self.playsCollection.backgroundColor = [UIColor clearColor];
        self.playsCollection.delegate = self;
        self.playsCollection.dataSource = self.playbookPlayDS;
        self.playsCollection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.playsCollection.scrollEnabled = YES;
        self.playbookPlayDS.playbook = selectedPlaybook;
        
        [self.playsCollection registerClass:[PlaybookPlayCell class] forCellWithReuseIdentifier:@"PlaybookPlayCell"];
        
        // animate - slide the new view up & hide the old one
        [self.view  addSubview:self.playsCollection];
        [self.view bringSubviewToFront:self.timerView];
        [UIView animateWithDuration:.4 animations: ^{
            self.playsCollection.frame = self.playbooksCollection.frame;
            self.playbooksCollection.alpha = 0.0;
            self.doneButton.alpha = 1;
        }];
        
        // gestures - drag & drop
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlayPanning:)];
        panRecognizer.delegate = self;
        [self.playsCollection addGestureRecognizer:panRecognizer];

        return;
    }
    [self performSegueWithIdentifier:@"playbookShowPlaySegue" sender:selectedPlaybookplay];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playbookShowPlaySegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CocosViewController *controller = (CocosViewController *) navigationController.topViewController;
        [controller setCurrentPlay:selectedPlaybookplay.play];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.playBookDS collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [self.playBookDS collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
}

-(void) handleCurrentPlayTap:(UITapGestureRecognizer *)recognizer{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - selected current play"]];
    selectedPlaybookplay = self.currentPlay;
    [self performSegueWithIdentifier:@"playbookShowPlaySegue" sender:selectedPlaybookplay];
}

@end
