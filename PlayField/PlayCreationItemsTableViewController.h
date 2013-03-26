//
//  PlayCreationItemViewController.h
//  GreaseBoard
//
//  Created by Jai Lebo on 2/9/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayCreationItemsDelegate
- (void)draggingStarted:(UIPanGestureRecognizer *)sender forItemWithName:(NSString *)name;
- (void)draggingChanged:(UIPanGestureRecognizer *)sender;
- (void)draggingEnded:(UIPanGestureRecognizer *)sender;
@end

@interface PlayCreationItemsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id<PlayCreationItemsDelegate> delegate;

- (IBAction)addSprite:(UIButton *)sender;

@end
