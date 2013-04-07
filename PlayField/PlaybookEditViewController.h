//
//  PlaybookEditViewController.h
//  PlayField
//
//  Created by Jai on 4/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbook.h"

@class PlaybookEditViewController;

@protocol PlaybookEditDelegate <NSObject>
- (void) playbookEdit:(PlaybookEditViewController *)controller saveEdit:(id)playbook;
@end

@interface PlaybookEditViewController : UITableViewController {
    NSArray *playbookTypes;
}

@property (nonatomic, weak) id <PlaybookEditDelegate> delegate;
@property (nonatomic, strong) Playbook *playbook;

@property (strong, nonatomic) IBOutlet UITextField *playbookName;
@property (strong, nonatomic) IBOutlet UITextView *notes;
@property (strong, nonatomic) IBOutlet UIPickerView *type;

- (IBAction)cancel:(id)sender;
- (IBAction)savePlaybook:(id)sender;

@end