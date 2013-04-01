//
//  CocosViewController.m
//  PlayField
//
//  Created by Jai Lebo on 2/16/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "CocosViewController.h"
#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "SavePlayViewController.h"
#import "SpritePoint.h"

@interface CocosViewController ()
@end

@implementation CocosViewController
{
    UIPopoverController *savePlayPopover;
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
    CCDirector *director = [CCDirector sharedDirector];
    
    if([director isViewLoaded] == NO)
    {
        // Create the OpenGL view that Cocos2D will render to.
        CCGLView *glView = [CCGLView viewWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]
                                       pixelFormat:kEAGLColorFormatRGB565
                                       depthFormat:0
                                preserveBackbuffer:NO
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
        
        // Assign the view to the director.
        director.view = glView;
        
        // Initialize other director settings.
        [director setAnimationInterval:1.0f/60.0f];
        [director enableRetinaDisplay:YES];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    // Add the director's OpenGL view as a subview so we can see it.
    [self.view addSubview:director.view];
    [self.view sendSubviewToBack:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    CCScene *scene = [HelloWorldLayer scene];
    
    // Run whatever scene we'd like to run here.
    [director pushScene:scene];
    
    _helloWorldLayer = [scene.children objectAtIndex:0];
}

- (void)setCurrentPlay:(Play *)pPlay
{
    if (_detailItem != pPlay) {
        _detailItem = pPlay;

        [_helloWorldLayer setCurrentPlay:self.detailItem];
        
        // Update the view.
        [self configureView];
    }
}

- (void)addItemSprite:(NSString *)itemName
{
    [_helloWorldLayer addItemSprite:itemName];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.title = self.detailItem.name;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) playCreationDetailsViewController:(PlayCreationDetailsViewController *)controller saveEdit:(id)editItem
{
    [self savePlay:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playDetailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PlayCreationDetailsViewController *editController = (PlayCreationDetailsViewController *) navigationController.topViewController;
        editController.delegate = self;
        editController.play = self.detailItem;
    } else if([segue.identifier isEqualToString:@"playSaveSegue"]) {
        //UIBarButtonItem *anchor = sender;
        
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    SavePlayViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"savePlayViewController"];
    viewControllerForPopover.delegate = self;
    if (savePlayPopover != nil && savePlayPopover.popoverVisible)
    {
        [savePlayPopover dismissPopoverAnimated:NO];
    }
    savePlayPopover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
    [savePlayPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)savePlay:(id)sender {
    [self configureView];
    // Save each PlaySprite SpritePoints.
    for( PlaySprite *ps in _helloWorldLayer.movableSprites ) {
        [ps saveSpritePoints];
    }

    // Save the context.
    NSError *error = nil;
    if (![self.detailItem.managedObjectContext save:&error]) {
        [self fatalCoreDataError:error];
        return;
    }
}

- (void) copyPlayInverted:(bool) inverted
{
    Play *newPlay = [NSEntityDescription insertNewObjectForEntityForName:@"Play" inManagedObjectContext:self.managedObjectContext];
    
    NSString *appendToName;
    if(inverted) {
        appendToName = @" - Reverse";
    } else {
        appendToName = @" - Duplicate";
    }
    NSString *dupName = [self.detailItem.name stringByAppendingString:appendToName ];
    newPlay.name = dupName;
    newPlay.notes = self.detailItem.notes;
    newPlay.type = self.detailItem.type;
    
    for(PlaySprite *psOld in self.detailItem.playSprite) {
        PlaySprite *psNew = [NSEntityDescription insertNewObjectForEntityForName:@"PlaySprite" inManagedObjectContext:self.managedObjectContext];
        psNew.play = newPlay;
        if(inverted) {
            CGPoint newPoint = [self reverseCGPoint:CGPointFromString(psOld.startingPosition)];
            psNew.startingPosition = NSStringFromCGPoint(newPoint);
        } else {
            psNew.startingPosition = psOld.startingPosition;
        }
        
        psNew.imageString = psOld.imageString;
        
        for(SpritePoint *spOld in psOld.spritePoints) {
            SpritePoint *spNew = [NSEntityDescription insertNewObjectForEntityForName:@"SpritePoint" inManagedObjectContext:self.managedObjectContext];
            spNew.order = spOld.order;
            if(inverted ) {
                CGPoint newPoint = [self reverseCGPoint:CGPointFromString(spOld.point)];
                spNew.point = NSStringFromCGPoint(newPoint);
            } else {
                spNew.point = spOld.point;
            }
            spNew.parentSprite = psNew;
        }
    }
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (CGPoint)reverseCGPoint:(CGPoint)oldPoint
{
    int center = 350; //TODO: should not be hardcoded.
    
    CGPoint newPoint;
    if(oldPoint.x < center) {
        newPoint = CGPointMake(center + (center - oldPoint.x), oldPoint.y);
    } else {
        newPoint = CGPointMake(center - (oldPoint.x - center), oldPoint.y);
    }
    return newPoint;
}

- (void)savePlayViewController:(SavePlayViewController *)controller
{
    [self savePlay:self];
    if (savePlayPopover != nil && savePlayPopover.popoverVisible)
    {
        [savePlayPopover dismissPopoverAnimated:YES];
        savePlayPopover = nil;
    }

}
- (void)saveDuplicatePlayViewController:(SavePlayViewController *)controller
{
    [self copyPlayInverted:false];
    if (savePlayPopover != nil && savePlayPopover.popoverVisible)
    {
        [savePlayPopover dismissPopoverAnimated:YES];
        savePlayPopover = nil;
    }
}
- (void)saveReversePlayViewController:(SavePlayViewController *)controller
{
    [self copyPlayInverted:true];
    if (savePlayPopover != nil && savePlayPopover.popoverVisible)
    {
        [savePlayPopover dismissPopoverAnimated:YES];
        savePlayPopover = nil;
    }
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlaySprite" inManagedObjectContext:self.detailItem.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //NSArray *sortDescriptors = @[sortDescriptor];
    //[fetchRequest setSortDescriptors:sortDescriptors];
    
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

- (void) fatalCoreDataError:(NSError *)error
{
    NSLog(@"*** Fatal error in %s:%d\n%@\n%@", __FILE__, __LINE__, error, [error userInfo]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internal Error", nil) message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}
@end
