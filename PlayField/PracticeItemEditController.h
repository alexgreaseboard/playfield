//
//  PracticeItemEditController.h
//  Flicker Search
//
//  Created by Emily Jeppson on 2/23/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeItem.h"

@class PracticeItem;
@class PracticeItemEditController;

// creating a delegate for the Add page - notify when I get canceled or saved
@protocol PracticeItemControllerDelegate <NSObject>

- (void)practiceItemController:(PracticeItemEditController *)controller didFinishEditingItem:(PracticeItem *)item;
- (void)practiceItemController:(PracticeItemEditController *)controller didDeleteItem:(PracticeItem *)item;

@end

@interface PracticeItemEditController : UITableViewController<UITextFieldDelegate>


@property (nonatomic, weak) id <PracticeItemControllerDelegate> delegate;
@property (nonatomic, strong) PracticeItem *practiceItem;
@property (strong, nonatomic) IBOutlet UITextField *practiceItemName;
@property (strong, nonatomic) IBOutlet UITextField *numberOfMinutes;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)deleteItem:(id)sender;
@end
