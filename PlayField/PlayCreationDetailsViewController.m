//
//  PlayCreationDetailsViewController.m
//  PlayField
//
//  Created by Jai on 2/20/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlayCreationDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PlayCreationDetailsViewController ()

@end

@implementation PlayCreationDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    playTypes = [[NSArray alloc] initWithObjects:@"Offense", @"Defense", @"Drill", nil];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.play) {
        self.playName.text = self.play.name;
        self.playNotes.text = self.play.notes;
        
        NSUInteger playTypeIndex = [playTypes indexOfObject:self.play.type];
        if( playTypeIndex != NSNotFound ) {
            [self.playType selectRow:playTypeIndex inComponent:0 animated:NO];
        }
    }
}

- (IBAction)savePlayDetails:(id)sender {
    self.play.name = self.playName.text;
    self.play.notes = self.playNotes.text;
    
    NSString *type = [playTypes objectAtIndex: [self.playType selectedRowInComponent:0]];
    self.play.type = type;
    
    [self.delegate playCreationDetailsViewController:self saveEdit:self.play];
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)cancelPlayDetails:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.textField becomeFirstResponder]; Change to auto pick first field
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return playTypes.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [playTypes objectAtIndex:row];
}

@end
