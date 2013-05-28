//
//  PlaybookDetailsViewController.m
//  PlayField
//
//  Created by Jai Lebo on 3/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookViewController.h"
#import "AppDelegate.h"
#import "PlaybookCell.h"
#import "PlaybookDetailViewController.h"
#import "Playbook.h"
#import "PlaybookPlay.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@interface PlaybookViewController () <UITextFieldDelegate>
@end

@implementation PlaybookViewController {
    CGRect initialDraggingFrame;
    PlaybookCell *draggingItem;
    PlaybookCell *hoveringOverCell;
    Play *draggingPlay;
    Playbook *draggingPlaybook;
}

Playbook *selectedPlaybook;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field.jpg"]];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    // data
    self.playBookDS = [[PlaybookDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.playbookPlayDS = [[PlaybookPlayDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];

    // allow the playbooks to be re-ordered
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    self.playbooksCollection.collectionViewLayout = layout;
    
    // set the datasources/delegates
    self.playbooksCollection.dataSource = self.playBookDS;
    self.playbooksCollection.delegate = self;
    self.playbooksCollection.backgroundColor = [UIColor clearColor];
    
    // gestures - pinch
    self.pinchOutGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handlePinchOutGesture:)];
    self.pinchOutGestureRecognizer.delegate = self;
    [self.playbooksCollection addGestureRecognizer:self.pinchOutGestureRecognizer];
    
    [self.playbooksCollection registerClass:[PlaybookCell class] forCellWithReuseIdentifier:@"PlaybookCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPlaybook:(id)sender {
    Playbook *newPlaybook = [NSEntityDescription insertNewObjectForEntityForName:@"Playbook" inManagedObjectContext:self.managedObjectContext];
    newPlaybook.name = @"New Playbook";
    newPlaybook.type = @"Offense";

    self.playBookDS.fetchedResultsController = nil;
    [self.playbooksCollection reloadData];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedPlaybook = [self.playBookDS.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"playbookDetailSegue" sender:selectedPlaybook];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playbookDetailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PlaybookDetailViewController *detailController = (PlaybookDetailViewController *) navigationController.topViewController;
        detailController.playbook = selectedPlaybook;
        detailController.parent = self;
    }
}

- (void) reloadData {
    [self.playbooksCollection reloadData];
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

- (void)draggingStarted:(UIPanGestureRecognizer *)sender forPlay:(Play *)pPlay {
	
    draggingPlay = pPlay;
	CGPoint touchPoint = [sender locationOfTouch:0 inView:self.playbooksCollection];
	initialDraggingFrame.origin = touchPoint;
	initialDraggingFrame.size.width = 100;
    initialDraggingFrame.size.height = 50;
	// center the cell
	//initialDraggingFrame.origin.x -= (initialDraggingFrame.size.width / 2);
	//initialDraggingFrame.origin.y -= (8 + self.playbooksCollection.contentOffset.y);
    
	// add the cell to the view
	draggingItem = [[PlaybookCell alloc] initWithFrame:initialDraggingFrame name:pPlay.name];

	[self.view addSubview:draggingItem];
}

- (void)draggingChanged:(UIPanGestureRecognizer *)sender{
	CGPoint translation = [sender translationInView:self.playbooksCollection];
	CGRect newFrame = initialDraggingFrame;
	newFrame.origin.x += translation.x;
	newFrame.origin.y += translation.y;
	draggingItem.frame = newFrame;
    
    [hoveringOverCell unhighlightCell];
    NSIndexPath *landingPoint = [self.playbooksCollection indexPathForItemAtPoint:newFrame.origin];
    if(landingPoint) {
        hoveringOverCell = (PlaybookCell *)[self.playbooksCollection cellForItemAtIndexPath:landingPoint];
        [hoveringOverCell highlightCell];
    } else {
        hoveringOverCell = nil;
    }
}

- (void)addPlayToPlaybook:(UIPanGestureRecognizer*)sender {
    // add the cell to the appropriate place
    CGPoint translation = [sender translationInView:self.playbooksCollection];
    CGRect newFrame = initialDraggingFrame;
    newFrame.origin.x += translation.x;
    newFrame.origin.y += translation.y;
    newFrame.origin.x += self.playbooksCollection.contentOffset.x;
    NSIndexPath *landingPoint = [self.playbooksCollection indexPathForItemAtPoint:newFrame.origin];
    
    if (landingPoint) {
        PlaybookPlay *newPlaybookPlay = [NSEntityDescription insertNewObjectForEntityForName:@"PlaybookPlay" inManagedObjectContext:self.managedObjectContext];
        Playbook *playbook = [self.playBookDS.fetchedResultsController objectAtIndexPath:landingPoint];
        newPlaybookPlay.playbook = playbook;
        newPlaybookPlay.play = draggingPlay;
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            [self fatalCoreDataError:error];
            return;
        }
    }
    [self.playbooksCollection reloadData];
    
}

- (void)draggingEnded:(UIPanGestureRecognizer *)sender
{
    [hoveringOverCell unhighlightCell];
	[self addPlayToPlaybook:sender];
    
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
    
- (void) fatalCoreDataError:(NSError *)error
{
    NSLog(@"*** Fatal error in %s:%d\n%@\n%@", __FILE__, __LINE__, error, [error userInfo]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internal Error", nil) message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

@end
