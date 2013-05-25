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

@interface GameTimeViewController ()

@end

@implementation GameTimeViewController{
    UICollectionViewCell *draggingCell;
	PlaybookPlay *draggingPlaybookPlay;
    Playbook *draggingPlaybook;
    CGRect initialDraggingFrame;
    bool upcomingPlayRemoved;
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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field.jpg"]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [self.view convertRect:self.collectionLabel.frame toView:self.view];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    //[self.view.layer insertSublayer:gradient below:self.collectionLabel.layer];
    
    self.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.2];
    self.offenseOrDefense = @"Defense";
    self.collectionLabel.text = @"Defense Playbooks";
    
    //disable buttons
    [self enableButtons];
    
    // data
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.playBookDS = [[PlaybookDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.playbookPlayDS = [[PlaybookPlayDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.upcomingPlaysDS = [[UpcomingPlaysDataSource alloc] init];
    [self switchType:nil];
    
    // set the datasources/delegates
    self.playbooksCollection.dataSource = self.playBookDS;
    self.playbooksCollection.delegate = self.playBookDS;
    self.upcomingPlaysCollection.dataSource = self.upcomingPlaysDS;
    self.upcomingPlaysCollection.delegate = self.upcomingPlaysDS;
    
    [self.playbooksCollection registerClass:[PlaybookCell class] forCellWithReuseIdentifier:@"PlaybookCell"];
    [self.upcomingPlaysCollection registerClass:[PlaybookPlayCell class] forCellWithReuseIdentifier:@"PlaybookPlayCell"];
    
    // gestures - pinch
    self.pinchOutGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handlePinchOutGesture:)];
    self.pinchOutGestureRecognizer.delegate = self;
    [self.playbooksCollection addGestureRecognizer:self.pinchOutGestureRecognizer];
    // gestures - drag & drop playbooks
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlaybookPanning:)];
    panRecognizer.delegate = self;
    [self.playbooksCollection addGestureRecognizer:panRecognizer];
    // gestures - drag & drop upcoming plays
    UIPanGestureRecognizer *upcomingPlaysGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpcomingPlaysPanning:)];
    upcomingPlaysGestureRecognizer.delegate = self;
    [self.upcomingPlaysCollection addGestureRecognizer:upcomingPlaysGestureRecognizer];
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
            draggingCell = [[PlaybookPlayCell alloc] initWithFrame:initialDraggingFrame playbookPlay:draggingPlaybookPlay];
            [self.view addSubview:draggingCell];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if(self.currentPannedItem == nil || draggingPlaybookPlay == nil){
            return;
        }
        //NSLog(@"Dragging changed");
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
        //NSLog(@"dragging ended");
        // add the cell to the appropriate place
        [self addDraggedCell:recognizer draggedItem:draggingPlaybookPlay];
        
        [draggingCell removeFromSuperview];
        draggingCell = nil;
        draggingPlaybookPlay = nil;
        [self enableButtons];
    }
}
    
- (void)addDraggedCell:(UIPanGestureRecognizer*)sender draggedItem:(NSObject*) draggedItem {
        // add the cell to the appropriate place
        CGPoint translation = [sender translationInView:self.upcomingPlaysCollection];
        CGRect newFrame = initialDraggingFrame;
        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;
        newFrame.origin.x += self.upcomingPlaysCollection.contentOffset.x;
        NSIndexPath *landingPoint = [self.upcomingPlaysCollection indexPathForItemAtPoint:newFrame.origin];
    
        if(landingPoint){
            [self.upcomingPlaysDS.upcomingPlays removeObject:draggingPlaybookPlay];
            //Play *landingItem = self.upcomingPlaysDS.upcomingPlays[landingPoint.item];
            int index = landingPoint.item;
            if(index > 0){
                index--;
            }
            [self.upcomingPlaysDS.upcomingPlays insertObject:draggedItem atIndex:index];
        } else if(newFrame.origin.x > 0 && newFrame.origin.y > 0 && newFrame.origin.x < self.upcomingPlaysCollection.frame.size.width && newFrame.origin.y < self.upcomingPlaysCollection.frame.size.height){
            [self.upcomingPlaysDS.upcomingPlays removeObject:draggedItem];
            [self.upcomingPlaysDS.upcomingPlays addObject:draggedItem];
        } else {
            //NSLog(@"Not dragging over upcoming plays %f %f", newFrame.origin.x, newFrame.origin.y);
        }
    [self.upcomingPlaysCollection reloadData];
        
}

// drag & drop for playbooks to upcoming plays
- (void)handlePlaybookPanning:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
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
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
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
        [self addDraggedCell:recognizer draggedItem:draggingPlaybook];
    } else {
        if(self.currentPannedItem == nil || draggingPlaybook == nil){
            return;
        }
        [self.upcomingPlaysDS.upcomingPlays removeObject:draggingPlaybook];
        // get all the plays associated with the current playbook and add them
        id <NSFetchedResultsSectionInfo> section = self.playbookPlayDS.fetchedResultsController.sections[0];
        for(PlaybookPlay *playbookPlay in [section objects]){
            [self addDraggedCell:recognizer draggedItem:playbookPlay];
        }
        
        [draggingCell removeFromSuperview];
        draggingCell = nil;
        draggingPlaybook = nil;
        [self enableButtons];
    }
}

- (void)handleUpcomingPlaysPanning:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // get the pinch point in the play books collection
        CGPoint pinchPoint = [recognizer locationInView:self.upcomingPlaysCollection];
        NSIndexPath *pannedItem = [self.upcomingPlaysCollection indexPathForItemAtPoint:pinchPoint];
        if (pannedItem) {
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
            
            draggingPlaybookPlay = [self.upcomingPlaysDS.upcomingPlays objectAtIndex:pannedItem.item];
            draggingCell = [[PlaybookPlayCell alloc] initWithFrame:initialDraggingFrame playbookPlay:draggingPlaybookPlay];
            [self.view addSubview:draggingCell];
            upcomingPlayRemoved = NO;
            //NSLog(@"Finding dragging play at index %d %@", pannedItem.item, draggingPlay);
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if(self.currentPannedItem == nil || draggingPlaybookPlay == nil){
            return;
        }
        //NSLog(@"Dragging changed");
        // move the cell around
        CGPoint translation = [recognizer translationInView:self.upcomingPlaysCollection];
        CGRect newFrame = initialDraggingFrame;
        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;
        draggingCell.frame = newFrame;
        
        //remove it if needed
        CGPoint location = [recognizer locationInView:self.upcomingPlaysCollection];
        NSLog(@"Location: %f Height: %f", location.y, self.upcomingPlaysCollection.frame.size.height);
        if(upcomingPlayRemoved == NO && location.y > (self.upcomingPlaysCollection.frame.size.height)){
            [self.upcomingPlaysDS.upcomingPlays removeObject:draggingPlaybookPlay];
            [self.upcomingPlaysCollection reloadData];
            upcomingPlayRemoved = YES;
        } else if(location.y <= (self.upcomingPlaysCollection.frame.size.height)){
            // add it back if needed
            [self addDraggedCell:recognizer draggedItem:draggingPlaybookPlay];
            upcomingPlayRemoved = NO;
        }
    } else {
        if(self.currentPannedItem == nil || draggingPlaybookPlay == nil){
            return;
        }
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
    if(self.upcomingPlaysDS.upcomingPlays.count > 0){
        self.nextPlayButton.enabled = YES;
        self.removeAllButton.enabled = YES;
        self.nextPlayButton.alpha = 1.0;
        self.removeAllButton.alpha = 1.0;
    } else {
        self.nextPlayButton.enabled = NO;
        self.removeAllButton.enabled = NO;
        self.nextPlayButton.alpha = 0.7f;
        self.removeAllButton.alpha = 0.7f;
    }
}

- (IBAction)loadNextPlay:(id)sender {
    // get the first play from upcoming plays
    if(self.upcomingPlaysDS.upcomingPlays.count > 0){
        PlaybookPlay *firstPlaybookPlay = self.upcomingPlaysDS.upcomingPlays[0];
        
        CGRect frame = CGRectMake(self.currentPlayView.frame.origin.x + 2, self.currentPlayView.frame.origin.y, 150, 150);
        UICollectionViewCell *cell = [[PlaybookPlayCell alloc] initWithFrame:frame playbookPlay:firstPlaybookPlay];
        [self.currentPlayView addSubview:cell];
        [self.upcomingPlaysDS.upcomingPlays removeObject:firstPlaybookPlay];
        [self.upcomingPlaysCollection reloadData];
        [self enableButtons];
    }
}

- (IBAction)removeAllPlays:(id)sender {
    [self.upcomingPlaysDS.upcomingPlays removeAllObjects];
    [self.upcomingPlaysCollection reloadData];
    [self enableButtons];
}

- (IBAction)switchType:(id)sender {
    NSString *newLabel = [NSString stringWithFormat:@"Switch to %@", self.offenseOrDefense];
    [self.switchTypeButton setTitle:newLabel forState:UIControlStateNormal];
    if([self.offenseOrDefense isEqualToString:@"Offense"]){
        self.offenseOrDefense = @"Defense";
        newLabel = [self.collectionLabel.text stringByReplacingOccurrencesOfString:@"Offense" withString:@"Defense"];
    } else {
        self.offenseOrDefense = @"Offense";
        newLabel = [self.collectionLabel.text stringByReplacingOccurrencesOfString:@"Defense" withString:@"Offense"];
    }
    [self.collectionLabel setText:newLabel];
    self.playBookDS.offenseOrDefense = self.offenseOrDefense;
    self.playbookPlayDS.offenseOrDefense = self.offenseOrDefense;
    [self.playbooksCollection reloadData];
    [self.playsCollection reloadData];
}
@end
