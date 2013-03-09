//
//  PracticeOptionsController.m
//  Flicker Search
//
//  Created by Emily Jeppson on 2/23/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import "PracticeOptionsController.h"
#import "AppDelegate.h"

@implementation PracticeOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.contentSizeForViewInPopover = CGSizeMake(240.0, 400.0);
    self.dragOptionsTable.dataSource = self;
    self.dragOptionsTable.scrollEnabled = NO;
    
    // gesture recognizer
    UIPanGestureRecognizer *panning = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanning:)];
    panning.minimumNumberOfTouches = 1;
    panning.maximumNumberOfTouches = 1;
    panning.delegate = self;
    [self.dragOptionsTable addGestureRecognizer:panning];
}

- (IBAction)addColumn:(id)sender {
    [self.delegate addColumn];
}

- (IBAction)generateRandomData:(id)sender {
    [self.delegate generateRandomData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DragCell"];
    
    UILabel *label = (UILabel *)[cell viewWithTag:88];
    if(indexPath.item == 0){
        label.text = @"Running 10 min";
    } else if(indexPath.item == 1){
        label.text = @"Drills 20 min";
    } else{
        label.text = @"Other 5 min";
    }
    return cell;
}

#pragma UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handlePanning:(UIPanGestureRecognizer *)sender {
    
    if(sender.state == UIGestureRecognizerStateBegan){
        CGPoint p1 = [sender locationOfTouch:0 inView:[self dragOptionsTable]];
        NSIndexPath *newPinchedIndexPath1 = [self.dragOptionsTable indexPathForRowAtPoint:p1];
        //get the label
        UITableViewCell *cell = [self.dragOptionsTable cellForRowAtIndexPath:newPinchedIndexPath1];
        UILabel *label = (UILabel *)[cell viewWithTag:88];
        PracticeItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeItem" inManagedObjectContext:self.managedObjectContext];
        item.itemName = label.text;
        if(newPinchedIndexPath1.item == 0){
            item.numberOfMinutes = [NSNumber numberWithInt:10];
        } else if(newPinchedIndexPath1.item == 1){
            item.numberOfMinutes = [NSNumber numberWithInt:20];
        } else {
            item.numberOfMinutes = [NSNumber numberWithInt:5];
        }
           
        [self.delegate draggingStarted:sender forItem:item];
    } else if(sender.state == UIGestureRecognizerStateChanged){
        [self.delegate draggingChanged:sender];
    } else if(sender.state == UIGestureRecognizerStateEnded){
        [self.delegate draggingEnded:sender];
    }

}
@end
