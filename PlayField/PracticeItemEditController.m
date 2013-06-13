//
//  PracticeItemEditController.m
//  Flicker Search
//
//  Created by Emily Jeppson on 2/23/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import "PracticeItemEditController.h"

@implementation PracticeItemEditController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeItemEdit - loading"]];
    
    NSString *label = @"Practice Item";
    self.deleteButton.title = [NSString stringWithFormat:@"Delete %@", label];
    self.title = [NSString stringWithFormat:@"%@ Edit", label];
    self.numberOfMinutes.text = [NSString stringWithFormat:@"%@",self.practiceItem.numberOfMinutes];
    
    self.practiceItemName.text = self.practiceItem.itemName;
}

-(IBAction)done:(id)sender{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeItemEdit - done"]];
    self.practiceItem.numberOfMinutes = [NSNumber numberWithInt:[self.numberOfMinutes.text integerValue]];
    self.practiceItem.itemName = self.practiceItemName.text;
    [self.delegate practiceItemController:self didFinishEditingItem:self.practiceItem];
}

-(IBAction)cancel:(id)sender{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeItemEdit - cancel"]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)deleteItem:(id)sender{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeItemEdit - delete item"]];
    [self.delegate practiceItemController:self didDeleteItem:self.practiceItem];
}

// listen for characters changing in the text field and enable the button if it has characters
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PracticeItemEdit - shouldChangeCharacters"]];
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    if([theTextField.restorationIdentifier isEqualToString:@"numberOfMinutes"]){
    // make sure we have a valid number in the text field

    if(newText.length == 0){
        self.doneButton.enabled = NO;
        return YES;
    } else if([newText integerValue] < 3){// don't allow the user to save values less than 3
        self.doneButton.enabled = NO;
        if([newText integerValue] == 0){
            return NO;
        } else {
            return YES;
        }
    } else {
        self.doneButton.enabled = YES;
        return YES;
    }
    } else{
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
