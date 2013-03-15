//
//  PracticeEditControllerViewController.h
//  PlayField
//
//  Created by Emily Jeppson on 3/15/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Practice;
@class PracticeEditViewController;

// creating a delegate for the Add page - notify when I get canceled or saved
@protocol PracticeEditControllerDelegate <NSObject>

- (void)practiceEditController:(PracticeEditViewController *)controller didFinishAddingPractice:(Practice *)practice;

@end

@interface PracticeEditViewController : UITableViewController<UITextFieldDelegate>


@property (nonatomic, weak) id <PracticeEditControllerDelegate> delegate;
@property (nonatomic, strong) Practice *practice;
@property (strong, nonatomic) IBOutlet UITextField *practiceName;
@property (strong, nonatomic) IBOutlet UITextField *practiceDuration;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

@end
