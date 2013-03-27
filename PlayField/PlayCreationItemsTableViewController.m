//
//  PlayCreationItemViewController.m
//  GreaseBoard
//
//  Created by Jai Lebo on 2/9/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import "PlayCreationItemsTableViewController.h"
#import "PlayDrillItem.h"
#import "PlayDrillItemCell.h"
#import "AppDelegate.h"
#import "CocosViewController.h"

@interface PlayCreationItemsTableViewController ()

@end

@implementation PlayCreationItemsTableViewController {
    NSMutableArray *_items;
    CocosViewController *detailViewController;
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
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(returnToMenu:) ];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    _items = [[NSMutableArray alloc] init];
    [_items addObject:[PlayDrillItem itemWithText:@"Offense" andWithImage:@"Smile.png"]];
    [_items addObject:[PlayDrillItem itemWithText:@"Defense" andWithImage:@"Sad.png"]];
    [_items addObject:[PlayDrillItem itemWithText:@"Cone" andWithImage:@"cone.jpeg"]];
    
    detailViewController = (CocosViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.delegate = (id<PlayCreationItemsDelegate>)detailViewController.helloWorldLayer;
    
    // gesture recognizer for drag & drop
    UIPanGestureRecognizer *panning = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanning:)];
    panning.minimumNumberOfTouches = 1;
    panning.maximumNumberOfTouches = 1;
    panning.delegate = self;
    [self.tableView addGestureRecognizer:panning];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    PlayDrillItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    // find the to-do item for this index
    int index = [indexPath row];
    PlayDrillItem *item = _items[index];
    // set the text
    cell.itemName.text = item.text;
    [cell.image setImage:item.image];
    
    return cell;
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = _items.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

- (IBAction)returnToMenu:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToMenu];
}

#pragma UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handlePanning:(UIPanGestureRecognizer *)sender {
    
    if(sender.state == UIGestureRecognizerStateBegan){
        //NSLog(@"Dragging started");
        CGPoint p1 = [sender locationOfTouch:0 inView:self.tableView];
        NSIndexPath *newPinchedIndexPath1 = [self.tableView indexPathForRowAtPoint:p1];
        //get the label
        PlayDrillItemCell *cell = (PlayDrillItemCell*)[self.tableView cellForRowAtIndexPath:newPinchedIndexPath1];
        [self.delegate draggingStarted:sender forItemWithName:cell.itemName.text];
    } else if(sender.state == UIGestureRecognizerStateChanged){
        [self.delegate draggingChanged:sender];
        //NSLog(@"Dragging..");
    } else if(sender.state == UIGestureRecognizerStateEnded){
        [self.delegate draggingEnded:sender];
        //NSLog(@"Dragging stopped");
    }
    
}

@end
