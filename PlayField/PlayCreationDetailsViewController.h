//
//  PlayCreationDetailsViewController.h
//  PlayField
//
//  Created by Jai on 2/20/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Play.h"

@class PlayCreationDetailsViewController;

@protocol PlayCreationDetailsViewControllerDelegate <NSObject>
- (void)playCreationDetailsViewController:(PlayCreationDetailsViewController *)controller saveEdit:(id)editItem;
@end

@interface PlayCreationDetailsViewController : UITableViewController {
    NSArray *playTypes;
    NSArray *playRunPasses;
}

@property (nonatomic, weak) id <PlayCreationDetailsViewControllerDelegate> delegate;
@property (strong, nonatomic) Play *play;

@property (strong, nonatomic) IBOutlet UITextField *playName;
@property (strong, nonatomic) IBOutlet UITextView *playNotes;
@property (strong, nonatomic) IBOutlet UIPickerView *playType;
@property (strong, nonatomic) IBOutlet UIPickerView *playRunPass;

- (IBAction)savePlayDetails:(id)sender;
- (IBAction)cancelPlayDetails:(id)sender;

@end
