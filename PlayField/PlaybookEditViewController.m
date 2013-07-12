//
//  PlaybookEditViewController.m
//  PlayField
//
//  Created by Jai on 4/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookEditViewController.h"

@interface PlaybookEditViewController ()

@end

@implementation PlaybookEditViewController

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
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookEdit - loading"]];
    playbookTypes = [[NSArray alloc] initWithObjects:@"Offense", @"Defense", @"Special Teams", @"Practice", nil];
    
    [self configureView ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureView {
    if( _playbook ) {
        _playbookName.text = _playbook.name;
        _notes.text = _playbook.notes;
        
        NSUInteger playbookTypeIndex = [playbookTypes indexOfObject:_playbook.type];
        if( playbookTypeIndex != NSNotFound ) {
            [_type selectRow:playbookTypeIndex inComponent:0 animated:NO];
        }
    }
}

- (IBAction)cancel:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookEdit - cancel"]];
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)savePlaybook:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookEdit - save %@", _playbookName.text]];
    self.playbook.name = _playbookName.text;
    self.playbook.notes = _notes.text;
    
    NSString *type = [playbookTypes objectAtIndex: [_type selectedRowInComponent:0]];
    _playbook.type = type;
    
    [self.delegate playbookEdit:self saveEdit:self.playbook];
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)deletePlaybook:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookEdit - delete"]];
    [self.presentingViewController dismissViewControllerAnimated:NO completion: nil];
    [self.delegate deletePlaybook:self.playbook];
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
    return playbookTypes.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [playbookTypes objectAtIndex:row];
}
@end
