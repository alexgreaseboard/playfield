//
//  ViewController.m
//
//  Created by Emily Jeppson on 2/13/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PracticeViewController.h"
#import "PracticeItemCell.h"
#import "StackedGridLayout.h"
#import "PracticeColumn.h"
#import "PracticeItem.h"
#import "Practice.h"
#import "PracticeItemEditController.h"
#import "PracticeOptionsController.h"
#import "PracticeColumnEditController.h"
#import "AppDelegate.h"

@interface PracticeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PracticeOptionsDelegate>
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *menuButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) StackedGridLayout *stackedGridLayout;
@property (nonatomic) double pixelRatio;
@property (nonatomic, strong) NSMutableDictionary *colorItemMap;
@property (nonatomic, strong) NSMutableArray *availableColors;
@property (nonatomic) int colorIndex;

@end

@implementation PracticeViewController{
    __weak UIPopoverController *practiceOptionsPopover;
	PracticeItemCell *draggingCell;
	PracticeItem *draggingItem;
    PracticeItem *placeholderItem; // a placeholder to expand the column when dragging
    CGRect initialDraggingFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.splitViewController.tabBarController.
    
    self.availableColors = [[NSMutableArray alloc] initWithCapacity:20];
    [self.availableColors addObject:[UIColor colorWithRed:.17 green:.26 blue:.37 alpha:0.75]];// blue
    [self.availableColors addObject:[UIColor colorWithRed:.66 green:.15 blue:.18 alpha:0.75]];// red
    [self.availableColors addObject:[UIColor colorWithRed:.31 green:.41 blue:.18 alpha:0.85]];// green
    [self.availableColors addObject:[UIColor colorWithRed:.20 green:.15 blue:.33 alpha:0.75]];// purple
    
    self.colorItemMap = [[NSMutableDictionary alloc] initWithCapacity:20];
}

// set the practice

-(void)resetViewWithPractice:(Practice*)practice{
    self.practice = practice;
    self.title = practice.practiceName;
    //calculate the pixel ratio based on the size of the frame and the duration of the practice
    CGRect screenRect = [self.view frame];
    screenRect.origin.y += 15;
    screenRect.size.height -=15;
    int headerHeight = HEADER_HEIGHT;
    self.pixelRatio = ((screenRect.size.height - 25 - headerHeight) / ([self.practice.practiceDuration integerValue]));
    if(self.pixelRatio < 8.0){
        self.pixelRatio = 8.0;
    }
    // generate the time labels
    for(PracticeColumn* column in practice.practiceColumns){
        [self generateTimeItemsForColumn:column];
    }
    
    // reset first
    [self.collectionView removeFromSuperview];
    [self.tableView removeFromSuperview];
    
    // stacked grid layout - the calendar portion
    self.stackedGridLayout = [[StackedGridLayout alloc] init];
    self.stackedGridLayout.headerHeight=0.0f;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:screenRect collectionViewLayout:self.stackedGridLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = self.stackedGridLayout;
    self.collectionView.allowsSelection = YES;
    self.collectionView.multipleTouchEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[PracticeItemCell class] forCellWithReuseIdentifier:@"PracticeCell"];

    //self.collectionView.frame = screenRect;
    [self.view addSubview:self.collectionView];
    
    //pinching cells
    UIPinchGestureRecognizer *pinching = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinching:)];
    pinching.delegate = self;
    [self.collectionView addGestureRecognizer:pinching];
    
    NSLog(@"Pixel Ratio: %f",self.pixelRatio);
    
    // table - the times behind the calendar
    CGRect tableFrame = screenRect;
    tableFrame.origin.y = tableFrame.origin.y + headerHeight - (5*self.pixelRatio);
    tableFrame.origin.x = 20;
    tableFrame.size.width = tableFrame.size.width + 200;
    
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame];
    self.tableView.dataSource = self,
    self.tableView.delegate = self;
    self.tableView.allowsSelection = NO;
    self.tableView.rowHeight = 5 * self.pixelRatio; // 5 minute intervals
    
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
    [self.view reloadInputViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // since we have 2 tables, make them scroll at the same time
    UIScrollView *otherScrollView = self.tableView;
    [otherScrollView setContentOffset:[scrollView contentOffset] animated:NO];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSInteger size = 0;
    for(PracticeColumn *practiceColumn in self.practice.practiceColumns){
        size += [practiceColumn.practiceItems count] + [practiceColumn.timePracticeItems count];
    }
    return size;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PracticeItem *practiceItem = [self findItemAtIndex:indexPath.item];
    PracticeItemCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PracticeCell" forIndexPath:indexPath];
    cell.hidden = NO;
    //NSLog(@"Configuring cell for item %@ and cell %@", practiceItem, cell);
    if([practiceItem.itemType isEqualToString:@"item"] && practiceItem.backgroundColor == nil){
        [self setColorForItem:practiceItem];
    }
    //NSLog(@"Drawing %d - %@", indexPath.item, practiceItem.backgroundColor);
    [cell configureCellForPracticeItem:practiceItem withframe:cell.frame];
    return cell;
}

-(void) setColorForItem:(PracticeItem*)practiceItem{
    if(practiceItem.itemName == nil){
        practiceItem.backgroundColor = [UIColor clearColor];
    } else if([self.colorItemMap valueForKey:practiceItem.itemName] == nil){
        UIColor *newColor = self.availableColors[self.colorIndex];
        self.colorIndex ++;
        if(self.colorIndex >= self.availableColors.count){
            self.colorIndex = 0;
        }
        practiceItem.backgroundColor = newColor;
        [self.colorItemMap setObject:newColor forKey:practiceItem.itemName];
    } else{
        practiceItem.backgroundColor = (UIColor*)[self.colorItemMap valueForKey:practiceItem.itemName];
    }
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

-(PracticeItem *) findItemAtIndex:(NSInteger)index{
    PracticeItem *item = nil;
    NSInteger count = 0;
    int columnNumber = 0;
    for(PracticeColumn *practiceColumn in self.practice.practiceColumns){
        
        NSInteger initialCount = count;
        count += practiceColumn.timePracticeItems.count;
        if(index < count){
            item = practiceColumn.timePracticeItems[count - initialCount - practiceColumn.timePracticeItems.count + (index - initialCount)];
            item.columnNumber = [NSNumber numberWithInt:columnNumber];
            break;
        }
        columnNumber ++;
        initialCount = count;
        count += practiceColumn.practiceItems.count;
        if(index < count){
            item = practiceColumn.practiceItems[count - initialCount - practiceColumn.practiceItems.count + (index - initialCount)];
            item.columnNumber = [NSNumber numberWithInt:columnNumber];
            break;
        }
        columnNumber ++;
    }
    return item;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PracticeItem *item = [self findItemAtIndex:indexPath.item];
    if([item.itemType isEqualToString:@"item"]){
        [self performSegueWithIdentifier:@"showPracticeItemEdit" sender:item];
    } else if([item.itemType isEqualToString:@"header"]){
        PracticeColumn *column = nil;
        for(int i=0; i<[self.practice.practiceColumns count]; i++){
            if(i == ( [item.columnNumber integerValue] / 2)){
                column = self.practice.practiceColumns[i];
            }
        }
        [self performSegueWithIdentifier:@"showPracticeColumnEdit" sender:column];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PracticeItem *item = [self findItemAtIndex:indexPath.item];
    CGSize retval = CGSizeMake(200, [item.numberOfMinutes integerValue]);
    if([item.itemType isEqualToString:@"time" ]){
        retval = CGSizeMake(10, [item.numberOfMinutes integerValue]);
    }
    
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

#pragma mark - StackedGridLayout
// number of columns
- (NSInteger)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl numberOfColumnsInSection:(NSInteger)section {
    return self.practice.practiceColumns.count * 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl itemInsetsForSectionAtIndex:(NSInteger)section {
    // pixels around each side
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGSize)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    PracticeItem *item = [self findItemAtIndex:indexPath.item];
    CGSize retval = CGSizeMake(width, [item.numberOfMinutes integerValue]);
    if([item.itemType rangeOfString:@"header"].location == NSNotFound ){
        retval.height = [item.numberOfMinutes integerValue] * self.pixelRatio;
        //NSLog(@"Minutes %d height %f",[item.numberOfMinutes integerValue], retval.height);
    }
    return retval;
}

- (NSInteger)findColumnForIndex:(NSInteger) index{
    PracticeItem *item = [self findItemAtIndex:index];
    return item.columnNumber.integerValue;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"showPracticeItemEdit"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PracticeItemEditController *practiceItemController = (PracticeItemEditController *)navigationController.topViewController;
        practiceItemController.delegate = self;
        practiceItemController.practiceItem = sender;
    } else if([segue.identifier isEqualToString:@"showPracticeOptionsPopover"]){
        PracticeOptionsController *controller = segue.destinationViewController;
        controller.delegate = self;
        practiceOptionsPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    } else if([segue.identifier isEqualToString:@"showPracticeColumnEdit"]){
        UINavigationController *navigationController = segue.destinationViewController;
        PracticeColumnEditController *practiceColumnController = (PracticeColumnEditController *)navigationController.topViewController;
        practiceColumnController.delegate = self;
        practiceColumnController.practiceColumn = sender;
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // should we show or hide the pop-over?
    if([identifier isEqualToString:@"showPracticeOptionsPopover"]){
        if (practiceOptionsPopover){
            [practiceOptionsPopover dismissPopoverAnimated:YES];
            return NO;
        }
        else
            return YES;
    }
    return YES;
}

-(IBAction)actionButtonTapped:(id)sender{
    [self performSegueWithIdentifier:@"showPracticeOptionsPopover" sender:sender];
}

#pragma mark - PracticeItemController
- (void)practiceItemController:(PracticeItemEditController *)controller didFinishEditingItem:(PracticeItem *)item{
    //[self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)practiceItemController:(PracticeItemEditController *)controller didDeleteItem:(PracticeItem *)item{
    // delete an item, not column
    if([item.itemType isEqualToString:@"item"] || [item.itemType isEqualToString:@"placeholder"]){
        for(int i=0; i< self.practice.practiceColumns.count; i++){
            if(([item.columnNumber integerValue] / 2) == i){
                PracticeColumn *column = self.practice.practiceColumns[i];
                [column removePracticeItemsObject:item];
                NSError *error = nil;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
                
            }
        }
        NSArray *indexes = [self.collectionView indexPathsForSelectedItems];
        [self.collectionView performBatchUpdates:^{ [self.collectionView deleteItemsAtIndexPaths:indexes];
        } completion:nil];
    } else{ // delete the entire column
        for(int i=0; i< self.practice.practiceColumns.count; i++){
            if(([item.columnNumber integerValue] / 2) == i){
                PracticeColumn *column = self.practice.practiceColumns[i];
                [self.practice removePracticeColumnsObject:column];
                NSError *error = nil;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        [self.collectionView reloadInputViews];
    }
    
    //[self.collectionView deleteItemsAtIndexPaths:indexes];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PracticeOptionsDelegate
- (void)addColumn{
    [practiceOptionsPopover dismissPopoverAnimated:YES];
    [self performSegueWithIdentifier:@"showPracticeColumnEdit" sender:nil];
}
-(void)generateRandomData{
    [practiceOptionsPopover dismissPopoverAnimated:YES];
    
    //add some test data
    for(int i =1; i<4; i++){
        // add the column header
        PracticeColumn *practiceColumn = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeColumn" inManagedObjectContext:self.managedObjectContext];
        practiceColumn.columnName = @"Column";
        [self practiceColumnEditController:nil didFinishAddingColumn:practiceColumn ];

        int count = [self.collectionView numberOfItemsInSection:0];
        // practice items
        for(int j=1; j<6;j++){
            PracticeItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeItem" inManagedObjectContext:self.managedObjectContext];
            item.itemType=@"item";
            item.itemName = [NSString stringWithFormat:@"Item %d",j];
            item.numberOfMinutes = [NSNumber numberWithInt:(((j * i) + (random()%33)) * 3) % 30];
            [practiceColumn addPracticeItemsObject:item];
            
            [self.collectionView performBatchUpdates:^{ [self.collectionView insertItemsAtIndexPaths:@[
                                                         [NSIndexPath indexPathForItem:count inSection:0]]];
            } completion:nil];
            count ++;
        }
         
    }
    [self.collectionView reloadData];
}

- (void)draggingStarted:(UIPanGestureRecognizer *)sender forPlayWithName:(NSString *)name{
	//NSLog(@"Dragging started");
    if(self.practice == nil){
        return;
    }
	CGPoint touchPoint = [sender locationOfTouch:0 inView:self.collectionView];
	initialDraggingFrame.origin = touchPoint;
	initialDraggingFrame.size.height = (10 * self.pixelRatio);
	initialDraggingFrame.size.width = 200;
	// center the cell
	initialDraggingFrame.origin.x -= (initialDraggingFrame.size.width / 2);
	initialDraggingFrame.origin.y -= (8 + self.collectionView.contentOffset.y);
    
	// add the cell to the view
	draggingItem = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeItem" inManagedObjectContext:self.managedObjectContext];
    draggingItem.itemType = @"item";
    draggingItem.numberOfMinutes = [NSNumber numberWithInt:10];
    draggingItem.itemName = name;
    [self setColorForItem:draggingItem];
    NSLog(@"Set %@ color to %@", draggingItem.itemType, draggingItem.backgroundColor);
	draggingCell = [[PracticeItemCell alloc] initWithFrame:initialDraggingFrame];
	[draggingCell configureCellForPracticeItem:draggingItem withframe:initialDraggingFrame];
	
    placeholderItem = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeItem" inManagedObjectContext:self.managedObjectContext];
    placeholderItem.itemType = @"placeholder";
    placeholderItem.numberOfMinutes = [NSNumber numberWithInt:10];
    placeholderItem.itemName = name;
	[self.view addSubview:draggingCell];
}

- (void)draggingChanged:(UIPanGestureRecognizer *)sender{
    if(self.practice == nil){
        return;
    }
	//NSLog(@"Dragging changed");
	// move the cell around
	CGPoint translation = [sender translationInView:self.collectionView];
	CGRect newFrame = initialDraggingFrame;
	newFrame.origin.x += translation.x;
	newFrame.origin.y += translation.y;
	draggingCell.frame = newFrame;
    //move the placeholder
    [self addDraggedCell:sender forItem:placeholderItem];
}

- (void)addDraggedCell:(UIPanGestureRecognizer*)sender forItem:(PracticeItem*)item{
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
}
- (void)draggingEnded:(UIPanGestureRecognizer *)sender{
    if(self.practice == nil){
        return;
    }
	NSLog(@"dragging ended");
    // add the cell to the appropriate place
	[self addDraggedCell:sender forItem:draggingItem];
    NSError *error = nil;
    [self.managedObjectContext deleteObject:placeholderItem];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

	[draggingCell removeFromSuperview];
	draggingCell = nil;
	draggingItem = nil;
}

#pragma mark - PracticeColumnEditDelegate
- (void)practiceColumnEditController:(PracticeColumnEditController *)controller didFinishAddingColumn:(PracticeColumn *)column{
    column.practice = self.practice;
    [self.practice addPracticeColumnsObject:column];
    int previousItemCount = [self.collectionView numberOfItemsInSection:0 ];
    int newItemCount = 1;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // add the column header
    PracticeItem *columnHeader = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeItem" inManagedObjectContext:self.managedObjectContext];
    [columnHeader createHeaderWithName:column.columnName];
    int height = HEADER_HEIGHT;
    columnHeader.numberOfMinutes = [NSNumber numberWithInt:height];
    [column addPracticeItemsObject:columnHeader];
    
    // add the time labels
    newItemCount += [self generateTimeItemsForColumn:column];
    //NSLog(@"Updating collection view");
    // update the collection view
    NSMutableArray *newIndexes = [[NSMutableArray alloc] initWithCapacity:newItemCount];
    for ( int i=0; i<newItemCount; i++){
        [newIndexes addObject:[NSIndexPath indexPathForItem:(previousItemCount + i) inSection:0]];
    }
    [self.collectionView performBatchUpdates:^{ [self.collectionView insertItemsAtIndexPaths:newIndexes];} completion:nil];
    
    // save & reload
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (int)generateTimeItemsForColumn:(PracticeColumn*)column{
    // add the time header
    PracticeItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeItem" inManagedObjectContext:self.managedObjectContext];
    [item createTimeHeader];
    column.timePracticeItems = [[NSMutableArray alloc] initWithCapacity:20];
    [column.timePracticeItems addObject:item];
    int newItemCount = 1;
    
    
    //generate the time items
    int practiceDuration = self.practice.practiceDuration.integerValue;
    for(int i=0; i<practiceDuration + 5; i+=5){
        int hours = i / 60;
        int minutes = i % 60;
        PracticeItem *timeItem = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeItem" inManagedObjectContext:self.managedObjectContext];
        [timeItem createTimeItemWithLabel:[NSString stringWithFormat:@"%02d:%02d",hours, minutes] ];
        [column.timePracticeItems addObject:timeItem];
        newItemCount ++;
    }
    return newItemCount;
}
- (void)practiceColumnEditController:(PracticeColumnEditController *)controller didFinishEditingColumn:(PracticeColumn *)column{
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)practiceItemController:(PracticeColumnEditController *)controller didDeleteColumn:(PracticeColumn *)column{
    // delete remove column
    [self.managedObjectContext deleteObject:column];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    //[self.practice.practiceColumns removeObject:column];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.practice.practiceDuration integerValue] / 5) + 2;
}

// tell the table what to display for the item @ indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimeCell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma UIPinchGestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void) handlePinching:(UIPinchGestureRecognizer *)sender{
    // Get the pinch points.
    CGPoint p1 = [sender locationOfTouch:0 inView:[self collectionView]];
    CGPoint p2 = [sender locationOfTouch:1 inView:[self collectionView]];
    NSIndexPath *newPinchedIndexPath1 = [self.collectionView indexPathForItemAtPoint:p1];
    NSIndexPath *newPinchedIndexPath2 = [self.collectionView indexPathForItemAtPoint:p2];
    
    PracticeItem *item1 = [self findItemAtIndex:newPinchedIndexPath1.item];
    PracticeItem *item2 = [self findItemAtIndex:newPinchedIndexPath2.item];
    
    //NSLog(@"Pinching %@, %@", item1.itemName, item2.itemName);
    if(sender.state == UIGestureRecognizerStateChanged && item1 == item2 && [item1.itemType isEqualToString:@"item"]){
        //increment by 5 minutes
        CGFloat newMinutes = [item1.numberOfMinutes floatValue] * sender.scale;
        NSInteger newMinutesInt = round(newMinutes);
        if(newMinutes > 0 && newMinutesInt % 5 == 0){
            item1.numberOfMinutes = [NSNumber numberWithInt:newMinutesInt];
            sender.scale = 1; // reset the scale
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        //disable animations to prevent delays
        BOOL animationsEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [self.collectionView reloadData];
        [UIView setAnimationsEnabled:animationsEnabled];
    }
}

@end
