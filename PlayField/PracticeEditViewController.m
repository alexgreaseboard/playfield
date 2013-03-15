//
//  PracticeEditControllerViewController.m
//  PlayField
//
//  Created by Emily Jeppson on 3/15/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PracticeEditViewController.h"
#import "Practice.h"

@interface PracticeEditViewController ()

@end

@implementation PracticeEditViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.doneButton.enabled = NO;
    self.title = @"New Practice";
}

-(IBAction)done:(id)sender{
    self.practice.practiceDuration = [NSNumber numberWithInt:[self.practiceDuration.text integerValue]];
    self.practice.practiceName = self.practiceName.text;
    [self.delegate practiceEditController:self didFinishAddingPractice:self.practice];
}

-(IBAction)cancel:(id)sender{
    [self.delegate practiceEditController:self didCancelAddingPractice:self.practice];
}

// listen for characters changing in the text field and enable the button if it has characters
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    if([theTextField.restorationIdentifier isEqualToString:@"practiceDurationText"]){
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
            if(self.practiceName.text.length > 0){
                self.doneButton.enabled = YES;
            }
            return YES;
        }
    } else{
        if(newText.length == 0){
            self.doneButton.enabled = NO;
        } else if(self.practiceDuration.text.length > 0){
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
