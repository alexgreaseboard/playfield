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
    PlaybookPlayDataSource *playbookPlayDS;
    PlaybookPlayCell *draggingItem;
    Play *draggingPlay;
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field.jpg"]];
    
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
    } else if ([segue.identifier isEqualToString:@"playbookPlayDetailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CocosViewController *controller = (CocosViewController *) navigationController;
        [controller setCurrentPlay:selectedPlaybookplay.play];
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

- (void)deletePlaybook:(Playbook *)playbook {
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
    [self.parent reloadData];
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pinchPoint = [recognizer locationInView:self.collectionView];
        NSIndexPath *landingPoint = [self.collectionView indexPathForItemAtPoint:pinchPoint];
        if (landingPoint) {
            initialDraggingFrame.origin = pinchPoint;
            initialDraggingFrame.size.height = 150;
            initialDraggingFrame.size.width = 150;
            // center the cell
            //initialDraggingFrame.origin.x -= (initialDraggingFrame.size.width / 2);
            //initialDraggingFrame.origin.y -= (8 + self.collectionView.contentOffset.y);
            // have we scrolled?
            //            initialDraggingFrame.origin.y -= [self.playsCollection contentOffset].y;
            //initialDraggingFrame.origin.y += (initialDraggingFrame.size.height);
            
            // add the cell to the view
            //draggingPlay = [self.playsDS.fetchedResultsController objectAtIndexPath:pannedItem];
            draggingItem = [[PlaybookPlayCell alloc] initWithFrame:initialDraggingFrame name:draggingPlay.name];
            [self.view addSubview:draggingItem];
        }
                
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.collectionView];
        CGRect newFrame = initialDraggingFrame;
        newFrame.origin.x += translation.x;
        newFrame.origin.y += translation.y;
        draggingItem.frame = newFrame;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [draggingItem removeFromSuperview];
        draggingItem = nil;
        draggingPlay = nil;
    }        
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedPlaybookplay = [playbookPlayDS.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"playbookPlayDetailSegue" sender:selectedPlaybookplay];
}

@end
