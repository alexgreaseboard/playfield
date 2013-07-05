//
//  DetailViewController.h
//  GreaseBoard
//
//  Created by Jai Lebo on 1/28/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RosterDetailEditViewController.h"

@class RosterDetailViewController;

@protocol RosterDetailViewControllerDelegate <NSObject>
- (void)rosterDetailViewController:(RosterDetailViewController *)controller saveDetail:(id)detailItem;
- (void)rosterDetailViewController:(RosterDetailViewController *)controller deleteItem:(id)detailItem;
@end

@interface RosterDetailViewController : UITableViewController <UISplitViewControllerDelegate,RosterDetailEditViewControllerDelegate>

@property (nonatomic, weak) id <RosterDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *backupPosition;
@property (weak, nonatomic) IBOutlet UILabel *height;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *time40;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
