//
//  SavePlayViewController.h
//  PlayField
//
//  Created by Jai on 2/27/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SavePlayViewController;

@protocol SavePlayViewControllerDelegate <NSObject>
- (void)savePlayViewController:(SavePlayViewController *)controller;
- (void)saveDuplicatePlayViewController:(SavePlayViewController *)controller;
- (void)saveReversePlayViewController:(SavePlayViewController *)controller;
@end

@interface SavePlayViewController : UIViewController

@property (nonatomic, weak) id <SavePlayViewControllerDelegate> delegate;

- (IBAction)savePlay:(id)sender;
- (IBAction)saveDuplicate:(id)sender;
- (IBAction)saveReverse:(id)sender;
@end
