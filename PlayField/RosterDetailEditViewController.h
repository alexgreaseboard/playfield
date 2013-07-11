//
//  RosterDetailEditViewController.h
//  GreaseBoard
//
//  Created by Jai on 1/31/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RosterDetailEditViewController;

@protocol RosterDetailEditViewControllerDelegate <NSObject>
- (void)rosterDetailEditViewController:(RosterDetailEditViewController *)controller saveEdit:(id)editItem;
- (void)rosterDetailEditViewController:(RosterDetailEditViewController *)controller deleteItem:(id)item;
@end

@interface RosterDetailEditViewController : UITableViewController

@property (nonatomic, weak) id <RosterDetailEditViewControllerDelegate> delegate;
@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *position;
@property (weak, nonatomic) IBOutlet UITextField *backupPosition;
@property (weak, nonatomic) IBOutlet UITextField *street;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *zipcode;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *height;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *time40;
@property (weak, nonatomic) IBOutlet UITextField *number;

- (IBAction)cancel;
- (IBAction)done;

@end
