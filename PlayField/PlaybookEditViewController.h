//
//  PlaybookEditViewController.h
//  PlayField
//
//  Created by Jai on 4/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Playbook.h"

@class PlaybookEditViewController;

@protocol PlaybookEditDelegate <NSObject>
- (void) playbookEdit:(PlaybookEditViewController *)controller saveEdit:(id)playbook;
- (void) deletePlaybook:(Playbook *)playbook;
@end

@interface PlaybookEditViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
    NSArray *playbookTypes;
}

@property (nonatomic, weak) id <PlaybookEditDelegate> delegate;
@property (nonatomic, strong) Playbook *playbook;

@property (strong, nonatomic) IBOutlet UITextField *playbookName;
@property (strong, nonatomic) IBOutlet UITextView *notes;
@property (strong, nonatomic) IBOutlet UIPickerView *type;

- (IBAction)cancel:(id)sender;
- (IBAction)savePlaybook:(id)sender;
- (IBAction)deletePlaybook:(id)sender;
- (IBAction)emailPlaybook:(id)sender;

@end
