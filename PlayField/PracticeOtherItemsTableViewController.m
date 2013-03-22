//
//  PracticeOtherItemsTableViewController.m
//  PlayField
//
//  Created by Emily Jeppson on 3/21/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PracticeOtherItemsTableViewController.h"

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
    [items addObject:@"Rest"];
    [items addObject:@"Other"];
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:43];
    label.text = items[indexPath.item];
    return cell;
}


@end
