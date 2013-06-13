//
//  RosterDetailEditViewController.m
//  GreaseBoard
//
//  Created by Jai on 1/31/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import "RosterDetailEditViewController.h"

@interface RosterDetailEditViewController ()

@end

@implementation RosterDetailEditViewController

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
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    // Update the user interface for the detail item.
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"RosterDetailEdit - configureView for %@", self.detailItem]];
    if (self.detailItem) {
        self.firstName.text = [[self.detailItem valueForKey:@"firstName"] description];
        self.lastName.text = [[self.detailItem valueForKey:@"lastName"] description];
        self.position.text = [[self.detailItem valueForKey:@"position"] description];
        self.backupPosition.text = [[self.detailItem valueForKey:@"backupPosition"] description];
        self.street.text = [[self.detailItem valueForKey:@"street"] description];
        self.city.text = [[self.detailItem valueForKey:@"city"] description];
        self.state.text = [[self.detailItem valueForKey:@"state"] description];
        self.zipcode.text = [[self.detailItem valueForKey:@"zipcode"] description];
        self.email.text = [[self.detailItem valueForKey:@"email"] description];
        self.phone.text = [[self.detailItem valueForKey:@"phone"] description];
        self.height.text = [[self.detailItem valueForKey:@"height"] description];
        self.weight.text = [[self.detailItem valueForKey:@"weight"] description];
        self.time40.text = [[self.detailItem valueForKey:@"time40"] description];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.textField becomeFirstResponder]; Change to auto pick first field
}

- (IBAction)cancel
{
    // If no first or last name, delete item.
    if( [[self.detailItem valueForKey:@"firstName"] description] == nil &&
        [[self.detailItem valueForKey:@"lastName"] description] == nil ) {
        [self.delegate rosterDetailEditViewController:self deleteItem:self.detailItem];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}
- (IBAction)done
{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"RosterDetailEdit - done for %@", self.detailItem]];
    [self.detailItem setValue:self.firstName.text forKey:@"firstName"];
    [self.detailItem setValue:self.lastName.text forKey:@"lastName"];
    [self.detailItem setValue:self.position.text forKey:@"position"];
    [self.detailItem setValue:self.backupPosition.text forKey:@"backupPosition"];
    [self.detailItem setValue:self.street.text forKey:@"street"];
    [self.detailItem setValue:self.city.text forKey:@"city"];
    [self.detailItem setValue:self.state.text forKey:@"state"];
    [self.detailItem setValue:self.zipcode.text forKey:@"zipcode"];
    [self.detailItem setValue:self.email.text forKey:@"email"];
    [self.detailItem setValue:self.phone.text forKey:@"phone"];
    [self.detailItem setValue:self.height.text forKey:@"height"];
    [self.detailItem setValue:self.weight.text forKey:@"weight"];
    [self.detailItem setValue:self.time40.text forKey:@"time40"];
    
    [self.delegate rosterDetailEditViewController:self saveEdit:self.detailItem];
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

@end
