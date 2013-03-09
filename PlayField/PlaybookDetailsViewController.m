//
//  PlaybookDetailsViewController.m
//  PlayField
//
//  Created by Jai Lebo on 3/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookDetailsViewController.h"
#import "AppDelegate.h"

@interface PlaybookDetailsViewController ()

@end

@implementation PlaybookDetailsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentPlaybook:(Playbook *)pPlaybook
{
    self.playbook = pPlaybook;
    self.title = self.playbook.name;
}

- (void) fatalCoreDataError:(NSError *)error
{
    NSLog(@"*** Fatal error in %s:%d\n%@\n%@", __FILE__, __LINE__, error, [error userInfo]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internal Error", nil) message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

@end
