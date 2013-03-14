//
//  DetailViewController.m
//  GreaseBoard
//
//  Created by Jai Lebo on 1/28/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import "RosterDetailViewController.h"

@interface RosterDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation RosterDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    //If 'item' doesn't have a firstName, assume new and display edit screen.
    if( [[self.detailItem valueForKey:@"firstName"] description] == nil ) {
        [self performSegueWithIdentifier:@"EditItemSegue" sender:self];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.name.text = [[[[self.detailItem valueForKey:@"firstName"] description] stringByAppendingString:@" "] stringByAppendingString:[[self.detailItem valueForKey:@"lastName"] description]];
        self.position.text = [[self.detailItem valueForKey:@"position"] description];
        self.backupPosition.text = [[self.detailItem valueForKey:@"backupPosition"] description];
        NSString *address = @"";
        if( [self.detailItem valueForKey:@"street"] != nil ) {
            address = [[self.detailItem valueForKey:@"street"] description];
            address = [ address stringByAppendingString:@"\n" ];
        }
        if( [self.detailItem valueForKey:@"city"] != nil ) {
            address = [ address stringByAppendingString:[[self.detailItem valueForKey:@"city"] description] ];
            address = [ address stringByAppendingString:@", " ];
        }
        if( [self.detailItem valueForKey:@"state"] != nil ) {
            address = [ address stringByAppendingString:[[self.detailItem valueForKey:@"state"] description] ];
            address = [ address stringByAppendingString:@"  "];
        }
        if( [self.detailItem valueForKey:@"zipcode"] != nil ) {
            address = [ address stringByAppendingString:[[self.detailItem valueForKey:@"zipcode"] description] ];
        }
        self.address.text = address;
        self.email.text = [[self.detailItem valueForKey:@"email"] description];
        self.phone.text = [[self.detailItem valueForKey:@"phone"] description];
        self.height.text = [[self.detailItem valueForKey:@"height"] description];
        self.weight.text = [[self.detailItem valueForKey:@"weight"] description];
        self.time40.text = [[self.detailItem valueForKey:@"time40"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rosterDetailEditViewController:(RosterDetailEditViewController *)controller saveEdit:(id)editItem
{
    [self configureView];
    [self.delegate rosterDetailViewController:self saveDetail:self.detailItem];
}

- (void)rosterDetailEditViewController:(RosterDetailEditViewController *)controller deleteItem:(id)item
{
    [self configureView];
    [self.delegate rosterDetailViewController:self deleteItem:self.detailItem];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditItemSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        RosterDetailEditViewController *editController = (RosterDetailEditViewController *) navigationController.topViewController;
        editController.delegate = self;
        editController.detailItem = self.detailItem;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
