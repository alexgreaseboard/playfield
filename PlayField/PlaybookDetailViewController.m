//
//  PlaybookDetailViewController.m
//  PlayField
//
//  Created by Jai on 3/14/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookDetailViewController.h"
#import "AppDelegate.h"
#import "PlaysDataSource.h"
#import "PlaybookCell.h"
#import "Play.h"

@interface PlaybookDetailViewController ()
@end

@implementation PlaybookDetailViewController {
    CGRect initialDraggingFrame;
    PlaysDataSource *playsDS;
    PlaybookCell *draggingItem;
    Play *draggingPlay;
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
    
    [self.collectionView registerClass:[PlaybookCell class] forCellWithReuseIdentifier:@"PlayCell"];
	
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // data
    playsDS = [[PlaysDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    // set the datasources/delegates
    self.collectionView.dataSource = playsDS;
    self.collectionView.delegate = self;
    
    [self configureView ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureView {
    if( _playbook ) {
        self.title = _playbook.name;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playbookEditSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PlaybookEditViewController *editController = (PlaybookEditViewController *) navigationController.topViewController;
        editController.delegate = self;
        editController.playbook = self.playbook; 
    }
}

- (void) playbookEdit:(PlaybookEditViewController *)controller saveEdit:(id)playbook {
    
    [self configureView];
    
    // Save the context.
    NSError *error = nil;
    if (![_playbook.managedObjectContext save:&error]) {
        [self fatalCoreDataError:error];
        return;
    }
}

- (void) fatalCoreDataError:(NSError *)error
{
    NSLog(@"*** Fatal error in %s:%d\n%@\n%@", __FILE__, __LINE__, error, [error userInfo]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internal Error", nil) message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)returnToPlaybooks:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}


- (void)draggingStarted:(UIPanGestureRecognizer *)sender forPlay:(Play *)pPlay {
	
    draggingPlay = pPlay;
	CGPoint touchPoint = [sender locationOfTouch:0 inView:self.collectionView];
	initialDraggingFrame.origin = touchPoint;
	initialDraggingFrame.size.width = 200;
	// center the cell
	initialDraggingFrame.origin.x -= (initialDraggingFrame.size.width / 2);
	initialDraggingFrame.origin.y -= (8 + self.collectionView.contentOffset.y);
    
	// add the cell to the view
	draggingItem.nameLabel.text = pPlay.name;
	draggingItem = [[PlaybookCell alloc] initWithFrame:initialDraggingFrame];
	
    /*placeholderItem = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeItem" inManagedObjectContext:self.managedObjectContext];
    placeholderItem.itemType = @"placeholder";
    placeholderItem.numberOfMinutes = [NSNumber numberWithInt:10];
    placeholderItem.itemName = name;*/
	[self.view addSubview:draggingItem];
}

- (void)draggingChanged:(UIPanGestureRecognizer *)sender{
	CGPoint translation = [sender translationInView:self.collectionView];
	CGRect newFrame = initialDraggingFrame;
	newFrame.origin.x += translation.x;
	newFrame.origin.y += translation.y;
	draggingItem.frame = newFrame;
    //move the placeholder
    //[self addDraggedCell:sender forItem:placeholderItem];
}


/*- (void)addDraggedCell:(UIPanGestureRecognizer*)sender forItem:(PracticeItem*)item{
    // add the cell to the appropriate place
	CGPoint translation = [sender translationInView:self.collectionView];
	CGRect newFrame = initialDraggingFrame;
	newFrame.origin.x += (translation.x + self.collectionView.contentOffset.x);
	newFrame.origin.y += (translation.y + self.collectionView.contentOffset.y);
	
	// find the column it was placed on
	if(self.practice.practiceColumns.count > 0){
		NSIndexPath *landingPoint = [self.collectionView indexPathForItemAtPoint:newFrame.origin];
		PracticeItem *landingItem = [self findItemAtIndex:landingPoint.item];
        if([landingItem.itemType isEqualToString:@"placeholder"]){
            landingItem = [self findItemAtIndex:(landingPoint.item + 1)];
        }
		if(landingPoint.item == 0){
			newFrame.origin.y = 15;
			landingPoint = [self.collectionView indexPathForItemAtPoint:newFrame.origin];
			landingItem = [self findItemAtIndex:landingPoint.item];
			PracticeColumn *column = [self.practice.practiceColumns objectAtIndex:([landingItem.columnNumber integerValue] / 2 )];
			if(column.practiceItems.count > 1){
				landingItem = column.practiceItems[column.practiceItems.count - 1];
			}
		}
		int column = [landingItem.columnNumber integerValue] / 2;
        
        // find where the item goes and add it
		PracticeColumn *landingColumn = self.practice.practiceColumns[column];
		for(int i=0; i<landingColumn.practiceItems.count; i++){
			PracticeItem *item = landingColumn.practiceItems[i];
            
			if([landingItem isEqual:item]){
                [landingColumn removePracticeItemsObject:draggingItem];
                if([landingColumn.practiceItems count] == i){
                    i--;
                }
                [landingColumn insertObject:draggingItem inPracticeItemsAtIndex:i+1];
				break;
			}
		}
	}
    [self.collectionView reloadData];
}*/
 
- (void)draggingEnded:(UIPanGestureRecognizer *)sender
{
	//[self addPlayToPlaybook:sender forItem:draggingItem];
    
    NSError *error = nil;
    //[self.managedObjectContext deleteObject:placeholderItem];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
	[draggingItem removeFromSuperview];
	draggingItem = nil;
    draggingPlay = nil;
}









@end
