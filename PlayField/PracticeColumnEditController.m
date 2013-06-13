//
//  PracticeColumnEditController.m
//  Flicker Search
//
//  Created by Emily Jeppson on 2/23/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import "PracticeColumnEditController.h"
#import "AppDelegate.h"

@implementation PracticeColumnEditController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeColumnEdit - loading"]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.title = @"New Column";
    if(self.practiceColumn != nil){
        self.columnNameTextField.text = self.practiceColumn.columnName;
        self.notesField.text = self.practiceColumn.notes;
        self.title = @"Edit Column";
    } else {
        [self.deleteButton setEnabled:NO];
    }
}

- (IBAction)done:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeColumnEdit - done"]];
    if(self.practiceColumn != nil){
        self.practiceColumn.columnName = self.columnNameTextField.text;
        self.practiceColumn.notes = self.notesField.text;
        [self.delegate practiceColumnEditController:self
                         didFinishEditingColumn:self.practiceColumn];
    } else {
        self.practiceColumn = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeColumn" inManagedObjectContext:self.managedObjectContext];
        self.practiceColumn.columnName = self.columnNameTextField.text;
        self.practiceColumn.notes = self.notesField.text;
        [self.delegate practiceColumnEditController:self didFinishAddingColumn:self.practiceColumn];
    }
}

- (IBAction)cancel:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeColumnEdit - cancel"]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteColumn:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeColumnEdit - deleteColumn"]];
    [self.delegate practiceItemController:self didDeleteColumn:self.practiceColumn];
}

// listen for characters changing in the text field and enable the button if it has characters
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeColumnEdit - shouldChangeCharactersInRange"]];
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    if([theTextField.restorationIdentifier isEqualToString:@"praticeColumnText"]){
        if(newText.length == 0){
            self.doneButton.enabled = NO;
        } else{
            self.doneButton.enabled = YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.doneButton.enabled = NO;
    return YES;
}
@end
