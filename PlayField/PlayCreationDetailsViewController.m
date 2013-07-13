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
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationDetails - loading"]];
    
    playTypes = [[NSArray alloc] initWithObjects:@"Offense", @"Defense", @"Drill", nil];
    playRunPasses = [[NSArray alloc] initWithObjects:@"Pass", @"Run", nil];
    
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
        
        NSUInteger playRunPassIndex = [playRunPasses indexOfObject:self.play.runPass];
        if( playRunPassIndex != NSNotFound ) {
            [self.playRunPass selectRow:playRunPassIndex inComponent:0 animated:NO];
        }
        
        NSString *playName = self.playName.text;
        if( [playName isEqual:@"New Offense"] || [playName isEqual:@"New Defense"] || [playName isEqual:@"New Drill"] ) {
            self.playName.text = @"";
            [self.playName selectAll:nil];
        }
    }
}

- (IBAction)savePlayDetails:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationDetails - savePlayDetails %@", self.playName.text]];
    self.play.name = self.playName.text;
    self.play.notes = self.playNotes.text;
    
    NSString *type = [playTypes objectAtIndex: [self.playType selectedRowInComponent:0]];
    self.play.type = type;
    
    NSString *runPass = [playRunPasses objectAtIndex: [self.playRunPass selectedRowInComponent:0]];
    self.play.runPass = runPass;
    
    [self.delegate playCreationDetailsViewController:self saveEdit:self.play];
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)cancelPlayDetails:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlayCreationDetails - cancelPlayDetails"]];
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
    if( pickerView.tag == 0 ) {
        return playTypes.count;
    } else if ( pickerView.tag == 1) {
        return playRunPasses.count;
    } else {
        return 0;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    if( pickerView.tag == 0 ) {
        return [playTypes objectAtIndex:row];
    } else if ( pickerView.tag == 1 ) {
        return [playRunPasses objectAtIndex:row];
    } else {
        return nil;
    }
}

@end
