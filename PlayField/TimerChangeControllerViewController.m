//
//  TimerChangeControllerViewController.m
//  greaseboard
//
//  Created by Emily Jeppson on 7/16/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "TimerChangeControllerViewController.h"

@interface TimerChangeControllerViewController ()

@end

@implementation TimerChangeControllerViewController

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
    CGRect frame = self.view.frame;
    frame.size.width = 100;
    frame.size.height = 200;
    self.view.frame = frame;
    self.modalPresentationStyle = UIModalPresentationFormSheet;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
