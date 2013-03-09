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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    if(self.practiceColumn != nil){
        self.columnNameTextField.text = self.practiceColumn.columnName;
    } 
}

- (IBAction)done:(id)sender {
    if(self.practiceColumn != nil){
        self.practiceColumn.columnName = self.columnNameTextField.text;
        [self.delegate practiceColumnEditController:self
                         didFinishEditingColumn:self.practiceColumn];
    } else {
        self.practiceColumn = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeColumn" inManagedObjectContext:self.managedObjectContext];
        self.practiceColumn.columnName = self.columnNameTextField.text;
        [self.delegate practiceColumnEditController:self didFinishAddingColumn:self.practiceColumn];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteColumn:(id)sender {
    [self.delegate practiceItemController:self didDeleteColumn:self.practiceColumn];
}

// listen for characters changing in the text field and enable the button if it has characters
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(newText.length == 0){
        self.doneButton.enabled = NO;
    } else{
        self.doneButton.enabled = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.doneButton.enabled = NO;
    return YES;
}
@end
