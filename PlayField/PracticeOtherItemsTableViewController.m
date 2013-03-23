//
//  PracticeOtherItemsTableViewController.m
//  PlayField
//
//  Created by Emily Jeppson on 3/21/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PracticeOtherItemsTableViewController.h"
#import "AppDelegate.h"

@interface PracticeOtherItemsTableViewController ()

@end

@implementation PracticeOtherItemsTableViewController{
    NSMutableArray* items;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    items = [[NSMutableArray alloc] init];
    [items addObject:@"Team Meeting"];
    [items addObject:@"Break"];
    [items addObject:@"Other"];
    
    // add the two buttons
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(returnToMenu:) ];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.delegate = (id<PracticeOtherItemsDelegate>)[[self.splitViewController.viewControllers lastObject] topViewController];
    // gesture recognizer for drag & drop
    UIPanGestureRecognizer *panning = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanning:)];
    panning.minimumNumberOfTouches = 1;
    panning.maximumNumberOfTouches = 1;
    panning.delegate = self;
    [self.tableView addGestureRecognizer:panning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PracticeOtherItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:43];
    label.text = items[indexPath.item];
    return cell;
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
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:newPinchedIndexPath1];
        UILabel *label = (UILabel *)[cell viewWithTag:43];
        if(label != nil){
            [self.delegate draggingStarted:sender forPlayWithName:label.text];
        }
    } else if(sender.state == UIGestureRecognizerStateChanged){
        [self.delegate draggingChanged:sender];
        //NSLog(@"Dragging..");
    } else if(sender.state == UIGestureRecognizerStateEnded){
        [self.delegate draggingEnded:sender];
        //NSLog(@"Dragging stopped");
    }
    
}


- (IBAction)returnToMenu:(id)sender
{
    //NSLog(@"Returning to menu");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchToMenu];
}

@end
