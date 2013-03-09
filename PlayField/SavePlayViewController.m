//
//  SavePlayViewController.m
//  PlayField
//
//  Created by Jai on 2/27/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "SavePlayViewController.h"

@interface SavePlayViewController ()

@end

@implementation SavePlayViewController

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

- (IBAction)savePlay:(id)sender {
    [self.cocosViewController savePlay:self];
}

- (IBAction)saveDuplicate:(id)sender {
    [self.cocosViewController saveDuplicate:self];
}

- (IBAction)saveReverse:(id)sender {
    [self.cocosViewController saveReverse:self];
}

@end
