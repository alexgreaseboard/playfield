//
//  PracticeColumnEditController.h
//  Flicker Search
//
//  Created by Emily Jeppson on 2/23/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeColumn.h"

@class PracticeColumn;
@class PracticeColumnEditController;

// creating a delegate for the Add page - notify when I get canceled or saved
@protocol PracticeColumnEditControllerDelegate <NSObject>

- (void)practiceColumnEditController:(PracticeColumnEditController *)controller didFinishAddingColumn:(PracticeColumn *)column;
- (void)practiceColumnEditController:(PracticeColumnEditController *)controller didFinishEditingColumn:(PracticeColumn *)column;
- (void)practiceItemController:(PracticeColumnEditController *)controller didDeleteColumn:(PracticeColumn *)column;

@end

@interface PracticeColumnEditController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, weak) id <PracticeColumnEditControllerDelegate> delegate;
@property (nonatomic, strong) PracticeColumn *practiceColumn;
@property (nonatomic, strong) NSString *test;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (strong, nonatomic) IBOutlet UITextField *columnNameTextField;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)deleteColumn:(id)sender;


@end
