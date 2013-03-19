//
//  PlaybookDetailViewController.m
//  PlayField
//
//  Created by Jai on 3/14/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookDetailViewController.h"

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnToPlaybooks:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}
@end
