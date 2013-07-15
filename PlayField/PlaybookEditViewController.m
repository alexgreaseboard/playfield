//
//  PlaybookEditViewController.m
//  PlayField
//
//  Created by Jai on 4/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookEditViewController.h"
#import "Play.h"

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

- (IBAction)emailPlaybook:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookEdit - emailPlaybook"]];
    [self showEmail:self];
}

- (IBAction)showEmail:(id)sender {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
    // Email Subject
    NSString *emailTitle = self.playbook.name;
    // Email Content
    NSString *messageBody = @"Playbook Name: ";
    if( self.playbookName.text != nil ) {
        messageBody = [messageBody stringByAppendingString:self.playbookName.text];
    }
    messageBody = [messageBody stringByAppendingString:@"\nPlaybook Type: "];
    messageBody = [messageBody stringByAppendingString:[playbookTypes objectAtIndex: [self.type selectedRowInComponent:0]]];
    messageBody = [messageBody stringByAppendingString:@"\nPlaybook Notes: "];
    if( self.notes.text != nil ) {
        messageBody = [messageBody stringByAppendingString:self.notes.text];
    }
    messageBody = [messageBody stringByAppendingString:@"\n\n\n"];
    
    for( PlaybookPlay *pp in self.playbook.playbookplays ) {
        messageBody = [messageBody stringByAppendingString:@"Play Name: "];
        if( pp.play.name != nil ) {
            messageBody = [messageBody stringByAppendingString:pp.play.name];
        }
        messageBody = [messageBody stringByAppendingString:@"\nPlay Type: "];
        if( pp.play.type != nil ) {
            messageBody = [messageBody stringByAppendingString:pp.play.type];
        }
        messageBody = [messageBody stringByAppendingString:@"\nRun or Pass: "];
        if( pp.play.runPass != nil ) {
            messageBody = [messageBody stringByAppendingString:pp.play.runPass];
        }
        messageBody = [messageBody stringByAppendingString:@"\nPlay Notes: "];
        if( pp.play.notes != nil ) {
            messageBody = [messageBody stringByAppendingString:pp.play.notes];
        }
        
        NSString *imageName;
        if( pp.play.name != nil ) {
            imageName = pp.play.name;
            imageName = [imageName stringByAppendingString:@".jpeg"];
        } else {
            imageName = @"Unknown.jpeg";
        }
        [mc addAttachmentData:pp.play.thumbnail mimeType:@"image/jpeg" fileName:imageName];
        
        messageBody = [messageBody stringByAppendingString:@"\n\n\n"];
    }
    
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
