//
//  PlaybookDetailViewController.m
//  PlayField
//
//  Created by Jai on 3/14/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookDetailViewController.h"
#import "AppDelegate.h"

@interface PlaybookDetailViewController ()
@end

@implementation PlaybookDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [self configureView ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureView {
    if( _playbook ) {
        self.title = _playbook.name;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playbookEditSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PlaybookEditViewController *editController = (PlaybookEditViewController *) navigationController.topViewController;
        editController.delegate = self;
        editController.playbook = self.playbook; 
    }
}

- (void) playbookEdit:(PlaybookEditViewController *)controller saveEdit:(id)playbook {
    
    [self configureView];
    
    // Save the context.
    NSError *error = nil;
    if (![_playbook.managedObjectContext save:&error]) {
        [self fatalCoreDataError:error];
        return;
    }
}

- (void) fatalCoreDataError:(NSError *)error
{
    NSLog(@"*** Fatal error in %s:%d\n%@\n%@", __FILE__, __LINE__, error, [error userInfo]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internal Error", nil) message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)returnToPlaybooks:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}
@end
