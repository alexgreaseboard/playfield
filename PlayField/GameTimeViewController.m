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
#import "LXReorderableCollectionViewFlowLayout.h"
#import <QuartzCore/QuartzCore.h>

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
    CAGradientLayer *currentPlayLayer;
    PlaybookPlayCell *currentPlayCell;
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
    
    self.timerView.parent = self;
    
    self.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    
    [self setupDataSources];
    [self setupGestures];
    
    // load the current game time object
    [self setupGametime];
    [self switchType:nil];
    
    //disable buttons
    [self enableButtons];
    [self arrangeScoreboard];
    
    // background image
    CGRect frame = self.view.frame;
    frame.size.width = 1024;
    frame.size.height = 768;
    UIGraphicsBeginImageContext(frame.size);
    [[UIImage imageNamed:@"field.jpg"] drawInRect:frame];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    frame = CGRectMake(0, 0, 400, 40);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:35.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = self.navigationItem.title;
    //CALayer *layer = label.layer;
    //[layer setCornerRadius:50];
     // emboss in the same way as the native title
    [label setShadowColor:[UIColor darkGrayColor]];
    [label setShadowOffset:CGSizeMake(0, -0.5)];
    self.navigationItem.titleView = label;
}

-(void) viewDidAppear:(BOOL)animated{
    self.typeButtons.selectedSegmentIndex = 0;
    [self.typeButtons sendActionsForControlEvents:UIControlEventValueChanged];
    [self arrangeScoreboard];
    
    CALayer *layer = [self.scoreboardView layer];
    [layer setCornerRadius:8.0f];
    [layer setBorderColor:[UIColor blackColor].CGColor];
    [layer setBorderWidth:1.0f];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"field.jpg"] drawInRect:self.scoreboardView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.scoreboardView.backgroundColor = [UIColor colorWithPatternImage:image];
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
    self.homeScoreStepper.value = gameTime.homeScore.intValue;
    self.awayScoreStepper.value = gameTime.awayScore.intValue;
    self.homeTOStepper.value = gameTime.homeTimeouts.intValue;
    self.awayTOStepper.value = gameTime.awayTimeouts.intValue;
    [self changeScore:nil];
    [self changeTimeouts:nil];
    
    if(gameTime.currentPlaybook){
        [self.gameButton setTitle:@"Stop Tracking Game" forState:UIControlStateNormal];
    } else {
        [self.gameButton setTitle:@"Start Tracking Game" forState:UIControlStateNormal];
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self addGradients];
}

- (void) arrangeScoreboard{
    [TestFlight passCheckpoint:@"GameTime - arrange scoreboard"];
    CGRect scoreboardFrame = self.scoreboardView.frame;
    scoreboardFrame.origin.x = 0 - scoreboardFrame.size.width + 200;
    scoreboardFrame.origin.y = self.view.frame.size.height - 47;
    self.scoreboardView.frame = scoreboardFrame;
    [self.view bringSubviewToFront:self.scoreboardView];
}

- (void) addGradients{
    // highlight the upcoming plays section
    currentPlayLayer = [CAGradientLayer layer];
    if(gameTime.currentPlaybook){
        currentPlayLayer.colors = [NSArray arrayWithObjects:
                                   (id)[UIColor colorWithWhite:1.0f alpha:0.3f].CGColor,
                                   (id)[UIColor colorWithWhite:1.0f alpha:0.05f].CGColor,
                                   (id)[UIColor colorWithWhite:1.0f alpha:0.05f].CGColor,
                                   (id)[UIColor colorWithWhite:1.0f alpha:0.3f].CGColor,
                                   nil];
    } else {
        currentPlayLayer.colors = [NSArray arrayWithObjects:
                                   (id)[UIColor colorWithWhite:0 alpha:0.4f].CGColor,
                                   (id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                                   (id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                                   (id)[UIColor colorWithWhite:0 alpha:0.4f].CGColor,
                                   nil];
    }
    currentPlayLayer.locations = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.15f],
                                  [NSNumber numberWithFloat:0.4f],
                                  [NSNumber numberWithFloat:0.6f],
                                  [NSNumber numberWithFloat:1.0f],
                                  nil];
    CGRect frame = self.currentPlayView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    currentPlayLayer.frame = frame;
    
    [self.currentPlayView.layer insertSublayer:currentPlayLayer above:self.currentPlayView.layer];
    
    UIView *upcomingView = [[UIView alloc] initWithFrame:self.upcomingPlaysCollection.frame];
    CAGradientLayer *upcomingLayer = [CAGradientLayer layer];
    upcomingLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:0 alpha:0.4f].CGColor,
                            (id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                            (id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                            (id)[UIColor colorWithWhite:0 alpha:0.4f].CGColor,
                            nil];
    upcomingLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.15f],
                               [NSNumber numberWithFloat:0.4f],
                               [NSNumber numberWithFloat:0.6f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    frame = upcomingView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = self.upcomingPlaysCollection.bounds.size.width + 300;
    upcomingLayer.frame = frame;
    [upcomingView.layer insertSublayer:upcomingLayer above:upcomingView.layer];
    self.upcomingPlaysCollection.backgroundView = upcomingView;
    
}

- (void) setupDataSources {
    // data
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.playBookDS = [[PlaybookDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.playbookPlayDS = [[PlaybookPlayDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.upcomingPlaysDS = [[PlaybookPlayDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    // set the datasources/delegates
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.upcomingPlaysCollection.collectionViewLayout = layout;
    self.playbooksCollection.dataSource = self.playBookDS;
    self.playbooksCollection.delegate = self;
    self.upcomingPlaysCollection.dataSource = self.upcomingPlaysDS;
    self.upcomingPlaysCollection.delegate = self;
    
    [self.playbooksCollection registerClass:[PlaybookCell class] forCellWithReuseIdentifier:@"PlaybookCell"];
    [self.upcomingPlaysCollection registerClass:[PlaybookPlayCell class] forCellWithReuseIdentifier:@"PlaybookPlayCell"];
}

- (void) setupGestures{
    [TestFlight passCheckpoint:@"GameTime -  setupGestures"];
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
            draggingPlaybookPlay.displayOrder = nil;
            PlaybookPlayCell *newCell = [[PlaybookPlayCell alloc] initWithFrame:initialDraggingFrame];
            [newCell configureCell:draggingPlaybookPlay];
            [newCell highlightCell];
            draggingCell = newCell;
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
        if(draggingPlaybookPlay.playbook == nil){
            [self.managedObjectContext deleteObject:draggingPlaybookPlay];
        }
        
        [self cleanupPlaybooks];
        [UIView setAnimationsEnabled:NO];
        [self.upcomingPlaysCollection reloadData];
        [draggingCell removeFromSuperview];
        draggingCell = nil;
        draggingPlaybookPlay = nil;
        [UIView setAnimationsEnabled:YES];
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
        draggedItem.play = play;
    }
    self.upcomingPlaysDS.playbook = upcomingPlaybook;
    [self.upcomingPlaysCollection reloadData];
    return draggedItem;
}

- (void) cleanupPlaybooks{
    self.upcomingPlaysDS.playbook = gameTime.upcomingPlaybook;
    id <NSFetchedResultsSectionInfo> section = self.upcomingPlaysDS.fetchedResultsController.sections[0];

    for(PlaybookPlay *playbookPlay in [section objects]){
        if(playbookPlay.displayOrder == nil){
            [self.managedObjectContext deleteObject:playbookPlay];
        } else {
            playbookPlay.status = nil;
        }
    }
    // reset the display order
    for(int i=0; i<self.upcomingPlaysDS.fetchedResultsController.fetchedObjects.count; i++){
        PlaybookPlay *pp = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:i];
        pp.displayOrder = [NSNumber numberWithInt:i];
    }

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
        // for clunky fingers - if they drag above the upcoming plays, still include it
        if(newFrame.origin.y < 15){
            newFrame.origin.y = 15;
        }
        NSIndexPath *landingPoint = [self.upcomingPlaysCollection indexPathForItemAtPoint:newFrame.origin];
        if(!landingPoint){
            CGPoint origin = newFrame.origin;
            origin.x += 11;
            landingPoint = [self.upcomingPlaysCollection indexPathForItemAtPoint:origin];
        }
        Boolean updates = NO;
    
        if(landingPoint){
            //NSLog(@"Landing point ------------- %i", landingPoint.item);
            //Play *landingItem = self.upcomingPlaysDS.upcomingPlays[landingPoint.item];
            int index = landingPoint.item;
            if(index > 0){
                index--;
            }
            
            if(draggedItem.displayOrder.intValue != index){
                //NSLog(@"Changing display order..");
                updates = YES;
                for( int i=[self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count]-1; i>=0; i--){
                    PlaybookPlay *pp = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:i];
                    if(pp != draggedItem){
                        if(i >= index){
                            pp.displayOrder = [NSNumber numberWithInt:(i+1)];
                        } else {
                            pp.displayOrder = [NSNumber numberWithInt:i];
                        }
                    }
                }
                draggedItem.displayOrder = [NSNumber numberWithInt:index];
            }
            
            draggedItem.playbook = gameTime.upcomingPlaybook;
        } else if(newFrame.origin.x > 0 && newFrame.origin.y > 0 && newFrame.origin.y < self.upcomingPlaysCollection.frame.size.height){
            
            int newIndex = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count];
            // NSLog(@"Old value %@ - %i",draggedItem.displayOrder, newIndex);
            if(draggedItem.displayOrder == nil || draggedItem.displayOrder.intValue != newIndex){
                NSLog(@"Adding to end");
                updates = YES;
                draggedItem.displayOrder = [NSNumber numberWithInt:newIndex];
                draggedItem.playbook = gameTime.upcomingPlaybook;
                for( int i=[self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count]-1; i>=0; i--){
                    PlaybookPlay *pp = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:i];
                    if(pp != draggedItem){
                        pp.displayOrder = [NSNumber numberWithInt:i];
                    }
                }

            }
        } else {
            if(draggedItem.playbook != nil){
                updates = YES;
                for( int i=[self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count]-1; i>=0; i--){
                    PlaybookPlay *pp = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:i];
                    if(pp != draggedItem && i > draggedItem.displayOrder.intValue){
                        pp.displayOrder = [NSNumber numberWithInt:(i-1)];
                    }
                }
                draggedItem.playbook = nil;
            }
            
            //NSLog(@"Not dragging over upcoming plays %f %f", newFrame.origin.x, newFrame.origin.y);
            //return;
        }
    
    if(updates){
        [UIView setAnimationsEnabled:NO];
        // save & reload
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.upcomingPlaysCollection reloadData];
        [UIView setAnimationsEnabled:YES];
        //NSLog(@"Loading updates...");
    }
    
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
    } else if(recognizer.state == UIGestureRecognizerStateChanged){ // changed or ended
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
        
        // is it within the upcoming plays section?
        CGPoint upcomingPlaysTanslation = [recognizer locationInView:self.upcomingPlaysCollection];
        //NSLog(@"UpcomingPlaysTanslation %f %f %f %f", upcomingPlaysTanslation.x
        //      , upcomingPlaysTanslation.y, self.upcomingPlaysCollection.bounds.size.width, self.upcomingPlaysCollection.bounds.size.height);
        if(upcomingPlaysTanslation.x > 0 && upcomingPlaysTanslation.y < self.upcomingPlaysCollection.bounds.size.height){
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - adding contents of playbook"]];
            
            self.playbookPlayDS.playbook = draggingPlaybook;
            self.playbookPlayDS.offenseOrDefense = nil;
            if([draggingPlaybook.playbookplays count] > 0){
                int index = draggingPlaybook.playbookplays.count;
                for(PlaybookPlay *playbookPlay in draggingPlaybook.playbookplays){
                    PlaybookPlay *newPp = [self createDraggingPlaybook:playbookPlay];
                    newPp.displayOrder = [NSNumber numberWithInt:index];
                    newPp.playbook = gameTime.upcomingPlaybook;
                    index ++;
                }
            }
            [draggingCell removeFromSuperview];
            draggingCell = nil;
            draggingPlaybook = nil;
            self.currentPannedItem = nil;
        }
        
    } else {
        [self cleanupPlaybooks];
        [draggingCell removeFromSuperview];
        draggingCell = nil;
        draggingPlaybook = nil;
        self.currentPannedItem = nil;
        [self enableButtons];
    }

}

// for removing plays from upcoming plays
- (void)handleUpcomingPlaysPanning:(UIPanGestureRecognizer *)recognizer
{
    /*
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // get the pinch point in the play books collection
        CGPoint pinchPoint = [recognizer locationInView:self.upcomingPlaysCollection];
        CGPoint translation = [recognizer translationInView:self.upcomingPlaysCollection];
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - started dragging upcoming play %f", translation.y]];
        NSIndexPath *pannedItem = [self.upcomingPlaysCollection indexPathForItemAtPoint:pinchPoint];
        if (pannedItem && translation.y >= 1) {
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - started removing upcoming play"]];
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
            draggingPlaybookPlay.displayOrder = nil;
            PlaybookPlayCell *newCell = [[PlaybookPlayCell alloc] initWithFrame:initialDraggingFrame];
            [newCell configureCell:draggingPlaybookPlay];
            [newCell highlightCell];
            draggingCell = newCell;
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
            //NSLog(@"Translation %f %f", translation.y, translation.x);
        
            [self.managedObjectContext deleteObject:draggingPlaybookPlay];
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            [self.upcomingPlaysCollection reloadData];
            upcomingPlayRemoved = YES;
            [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - removed upcoming play %@", draggingPlaybookPlay]];
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
     */
}

#pragma UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma GameTimeViewController
- (void) enableButtons{
    if([self.upcomingPlaysCollection numberOfItemsInSection:0] > 0){
        [self.nextPlayButton setEnabled: YES];
        [self.removeAllButton setEnabled: YES];
    } else {
        [self.nextPlayButton setEnabled: NO];
        [self.removeAllButton setEnabled: NO];
        if(self.currentPlay){
            [self.removeAllButton setEnabled:YES];
        }
    }
    
}

- (IBAction)loadNextPlay:(id)sender {
    // get the first play from upcoming plays
    if([self.upcomingPlaysDS.fetchedResultsController.fetchedObjects count] > 0){
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - load next play"]];
        if(self.currentPlay){
            [self.managedObjectContext deleteObject:self.currentPlay];
        }
        PlaybookPlay *firstPlaybookPlay = [self.upcomingPlaysDS.fetchedResultsController.fetchedObjects objectAtIndex:0];
        
        CGRect frame = CGRectMake(self.currentPlayView.frame.origin.x + 2, self.currentPlayView.frame.origin.y, 150, 150);
        if(currentPlayCell){
            [currentPlayCell removeFromSuperview];
        }
        currentPlayCell = [[PlaybookPlayCell alloc] initWithFrame:frame];
        [currentPlayCell configureCell:firstPlaybookPlay];
        [self.currentPlayView addSubview:currentPlayCell];
        NSLog(@"First play %@", firstPlaybookPlay.play.name);
        self.currentPlay = firstPlaybookPlay;
        NSLog(@"First play %@", self.currentPlay.play.name);
        // if we're recording the game, add this play to the gametime playbook
        if(gameTime.currentPlaybook){
            PlaybookPlay *newPlaybookPlay = [NSEntityDescription insertNewObjectForEntityForName:@"PlaybookPlay" inManagedObjectContext:self.managedObjectContext];
            newPlaybookPlay.play = firstPlaybookPlay.play;
            newPlaybookPlay.playbook = gameTime.currentPlaybook;
            newPlaybookPlay.displayOrder = [NSNumber numberWithInt:[gameTime.currentPlaybook.playbookplays count]];
        }
        
        firstPlaybookPlay.playbook = nil; // remove it from upcoming plays
        for(PlaybookPlay *pp in self.upcomingPlaysDS.fetchedResultsController.fetchedObjects){
            pp.displayOrder = [NSNumber numberWithInt:pp.displayOrder.intValue - 1];
        }
        //save
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
    // delete upcoming plays
    for(PlaybookPlay *pp in self.upcomingPlaysDS.fetchedResultsController.fetchedObjects){
        [self.managedObjectContext deleteObject:pp];
    }
    // delete the current play
    if(self.currentPlay){
        [self.managedObjectContext deleteObject:self.currentPlay];
        [currentPlayCell removeFromSuperview];
        self.currentPlay = nil;
    }
    // save
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    selectedPlaybookplay = nil;
    [UIView setAnimationsEnabled:NO];
    [self.upcomingPlaysCollection reloadData];
    [UIView setAnimationsEnabled:YES];
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
    [self enableButtons];
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
    
    [self.collectionLabel setText:[self.collectionLabel.text stringByReplacingOccurrencesOfString:@"Plays" withString:@"Playbooks" ]];
}

- (IBAction)toggleGame:(id)sender {
    if(gameTime.currentPlaybook){ // stop recording the game
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - stop tracking game"]];
        if([gameTime.currentPlaybook.playbookplays count] == 0){
            // if no plays were added, don't create a new playbook
            [self.managedObjectContext deleteObject:gameTime.currentPlaybook];
        }
        gameTime.currentPlaybook = nil;
        [self.gameButton setTitle:@"Start Tracking Game" forState:UIControlStateNormal];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        currentPlayLayer.colors = [NSArray arrayWithObjects:
                                   (id)[UIColor colorWithWhite:0 alpha:0.4f].CGColor,
                                   (id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                                   (id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                                   (id)[UIColor colorWithWhite:0 alpha:0.4f].CGColor,
                                   nil];
    } else {
        // start tracking the game
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - start tracking game"]];
        Playbook *newPlaybook = [NSEntityDescription insertNewObjectForEntityForName:@"Playbook" inManagedObjectContext:self.managedObjectContext];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM-dd-yyyy HH:mm"];
        newPlaybook.name = [NSString stringWithFormat:@"Game %@", [formatter stringFromDate:[NSDate date]]];
        newPlaybook.type = @"Offense";
        
        gameTime.currentPlaybook = newPlaybook;
        [self.gameButton setTitle:@"Stop Tracking Game" forState:UIControlStateNormal];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        currentPlayLayer.colors = [NSArray arrayWithObjects:
                                   (id)[UIColor colorWithWhite:1.0f alpha:0.3f].CGColor,
                                   (id)[UIColor colorWithWhite:1.0f alpha:0.05f].CGColor,
                                   (id)[UIColor colorWithWhite:1.0f alpha:0.05f].CGColor,
                                   (id)[UIColor colorWithWhite:1.0f alpha:0.3f].CGColor,
                                   nil];
    }
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
        [self.view bringSubviewToFront:self.scoreboardView];
        [UIView animateWithDuration:.4 animations: ^{
            self.playsCollection.frame = self.playbooksCollection.frame;
            self.playbooksCollection.alpha = 0.0;
            self.doneButton.alpha = 1;
        }];
        [self.collectionLabel setText:[self.collectionLabel.text stringByReplacingOccurrencesOfString:@"Playbooks" withString:@"Plays" ]];
        
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
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - selected current play %@", self.currentPlay.play.name]];
    selectedPlaybookplay = self.currentPlay;
    if(selectedPlaybookplay){
        [self performSegueWithIdentifier:@"playbookShowPlaySegue" sender:selectedPlaybookplay];
    }
}

- (IBAction)changeScore:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - change away score"]];
    gameTime.awayScore = [NSNumber numberWithFloat:self.awayScoreStepper.value];
    gameTime.homeScore = [NSNumber numberWithFloat:self.homeScoreStepper.value];
    [self.awayScoreLbl setText:[NSString stringWithFormat:@"%02u", gameTime.awayScore.intValue]];
    [self.homeScoreLbl setText:[NSString stringWithFormat:@"%02u", gameTime.homeScore.intValue]];
    [self setScoresLblValue];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (IBAction)toggleScoreboard:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - toggle scoreboard"]];
    if([self.scoreboardButton.titleLabel.text isEqualToString:@"Show"]){
        [self.scoreboardButton setTitle:@"Hide" forState:UIControlStateNormal];
        CGRect newFrame = self.scoreboardView.frame;
        newFrame.origin.x = (self.view.frame.size.width / 2 ) - (self.scoreboardView.frame.size.width / 2);
        newFrame.origin.y = (self.view.frame.size.height / 2) - (self.scoreboardView.frame.size.height / 2);
        [UIView animateWithDuration:.4 animations: ^{
            self.scoreboardView.frame = newFrame;
            self.scoreboardLabel.textAlignment = NSTextAlignmentCenter;
            self.scoresLbl.textAlignment = NSTextAlignmentCenter;
        }];
    } else {
        [self.scoreboardButton setTitle:@"Show" forState:UIControlStateNormal];
        [UIView animateWithDuration:.4 animations: ^{
            [self arrangeScoreboard];
            self.scoreboardLabel.textAlignment = NSTextAlignmentRight;
            self.scoresLbl.textAlignment = NSTextAlignmentRight;
        }];
    }
}

- (IBAction)resetScoreboard:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - reset scoreboard"]];
    self.awayScoreStepper.value = 0;
    self.homeScoreStepper.value = 0;
    self.homeTOStepper.value = 3;
    self.awayTOStepper.value = 3;
    [self changeScore:nil];
    [self changeTimeouts:nil];
}

- (IBAction)changeTimeouts:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"GameTime - change timeouts"]];
    gameTime.homeTimeouts = [NSNumber numberWithFloat:self.homeTOStepper.value];
    gameTime.awayTimeouts = [NSNumber numberWithFloat:self.awayTOStepper.value];
    NSString *lbl = @"";
    for( int i=0; i< self.homeTOStepper.value; i++){
        lbl = [NSString stringWithFormat:@"%@%@", lbl, @"| "];
    }
    [self.homeTOLbl setText:lbl];
    
    lbl = @"";
    for( int i=0; i< self.awayTOStepper.value; i++){
        lbl = [NSString stringWithFormat:@"%@%@", lbl, @"| "];
    }
    [self.awayTOLbl setText:lbl];
    [self setScoresLblValue];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) setScoresLblValue{
    [self.scoresLbl setText:[NSString stringWithFormat:@"Score: %@/%@ TO: %@/%@", gameTime.homeScore, gameTime.awayScore, gameTime.homeTimeouts, gameTime.awayTimeouts]];
}
@end
