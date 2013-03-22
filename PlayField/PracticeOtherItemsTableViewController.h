//
//  PracticeOtherItemsTableViewController.h
//  PlayField
//
//  Created by Emily Jeppson on 3/21/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>

// Drag & drop
@protocol PracticeOtherItemsDelegate
- (void)draggingStarted:(UIPanGestureRecognizer *)sender forPlayWithName:(NSString *)name;
- (void)draggingChanged:(UIPanGestureRecognizer *)sender;
- (void)draggingEnded:(UIPanGestureRecognizer *)sender;
@end

@interface PracticeOtherItemsTableViewController : UITableViewController<UIGestureRecognizerDelegate>
@property (nonatomic, strong) id<PracticeOtherItemsDelegate> delegate;
@end
