//
//  PlaybookDetailViewController.m
//  PlayField
//
//  Created by Jai on 3/14/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookDetailViewController.h"
#import "AppDelegate.h"
#import "PlaybookPlayDataSource.h"
#import "PlaybookPlayCell.h"
#import "Play.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@interface PlaybookDetailViewController ()
@end

@implementation PlaybookDetailViewController {
    CGRect initialDraggingFrame;
    CGPoint initialMainTouchPoint;
    PlaybookPlayDataSource *playbookPlayDS;
    PlaybookPlayCell *draggingItem;
    PlaybookPlay *draggingPlaybookPlay;
    PlaybookPlay *selectedPlaybookplay;
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
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookDetail - loading"]];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field.jpg"]];
    
    [self.collectionView registerClass:[PlaybookPlayCell class] forCellWithReuseIdentifier:@"PlaybookPlayCell"];
	
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // data
    playbookPlayDS = [[PlaybookPlayDataSource alloc] initWithManagedObjectContext:self.managedObjectContext];
    playbookPlayDS.playbook = self.playbook;
    
    // set the datasources/delegates
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = playbookPlayDS;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
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
    } else if ([segue.identifier isEqualToString:@"playbookShowPlaySegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CocosViewController *controller = (CocosViewController *) navigationController.topViewController;
        [controller setCurrentPlay:selectedPlaybookplay.play];
    }
}

- (void) playbookEdit:(PlaybookEditViewController *)controller saveEdit:(id)playbook {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookDetail - savePlaybookEdit"]];
    [self configureView];
    
    // Save the context.
    NSError *error = nil;
    if (![_playbook.managedObjectContext save:&error]) {
        [self fatalCoreDataError:error];
        return;
    }
}

- (void)deletePlaybook:(Playbook *)playbook {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookDetail - delete playbook %@", playbook]];
    [self.managedObjectContext deleteObject:playbook];
    // Save the context.
    NSError *error = nil;
    if (![_playbook.managedObjectContext save:&error]) {
        [self fatalCoreDataError:error];
        return;
    }
    [self returnToPlaybooks:self];
}

- (void) fatalCoreDataError:(NSError *)error
{
    NSLog(@"*** Fatal error in %s:%d\n%@\n%@", __FILE__, __LINE__, error, [error userInfo]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internal Error", nil) message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)returnToPlaybooks:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookDetail - returnToPlaybooks"]];
    [self.parent reloadData];
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint collectionTouchPoint = [recognizer locationInView:self.collectionView];
        NSIndexPath *landingPoint = [self.collectionView indexPathForItemAtPoint:collectionTouchPoint];
        if (landingPoint) {
            initialMainTouchPoint = [recognizer locationInView:self.view];
            initialDraggingFrame.origin = collectionTouchPoint;
            initialDraggingFrame.size.height = 150;
            initialDraggingFrame.size.width = 150;
            // center the cell
            initialDraggingFrame.origin.x -= (initialDraggingFrame.size.width / 2);
            //initialDraggingFrame.origin.y -= (8 + self.collectionView.contentOffset.y);
            // have we scrolled?
            initialDraggingFrame.origin.y -= [self.collectionView contentOffset].y;
            initialDraggingFrame.origin.y -= (initialDraggingFrame.size.height / 2);
            
            // add the cell to the view
            draggingPlaybookPlay = [playbookPlayDS.fetchedResultsController objectAtIndexPath:landingPoint];
            draggingItem = [[PlaybookPlayCell alloc] initWithFrame:initialDraggingFrame name:draggingPlaybookPlay.play.name];
            [self.view addSubview:draggingItem];
        }
                
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.view];
        CGRect newFrame = initialDraggingFrame;
        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;
        draggingItem.frame = newFrame;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if( draggingItem != nil ) {
            CGPoint translation = [recognizer translationInView:self.mainView];
            translation.x = translation.x + initialMainTouchPoint.x;
            translation.y = translation.y + initialMainTouchPoint.y;
            if (CGRectContainsPoint([self.trashCan frame], translation)) {
                [self deletePlaybookPlay:draggingPlaybookPlay];
            }
            [draggingItem removeFromSuperview];
        }
        draggingItem = nil;
        draggingPlaybookPlay = nil;
    }        
}

- (void) deletePlaybookPlay:(PlaybookPlay *)playbookPlay {
    [self.managedObjectContext deleteObject:playbookPlay];
    [self.collectionView reloadData];
    // Save the context.
    NSError *error = nil;
    if (![_playbook.managedObjectContext save:&error]) {
        [self fatalCoreDataError:error];
        return;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedPlaybookplay = [playbookPlayDS.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"playbookShowPlaySegue" sender:selectedPlaybookplay];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(150, 150);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
