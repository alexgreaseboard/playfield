//
//  PlayCreationItemViewController.h
//  GreaseBoard
//
//  Created by Jai Lebo on 2/9/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocosViewController.h"

@interface PlayCreationItemsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CocosViewController *detailViewController;

- (IBAction)addSprite:(UIButton *)sender;

@end
