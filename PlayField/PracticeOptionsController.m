//
//  PracticeOptionsController.m
//  Flicker Search
//
//  Created by Emily Jeppson on 2/23/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import "PracticeOptionsController.h"
#import "AppDelegate.h"

@implementation PracticeOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(240.0, 100.0);
}

- (IBAction)addColumn:(id)sender {
    [self.delegate addColumn];
}

- (IBAction)generateRandomData:(id)sender {
    [self.delegate generateRandomData];
}

@end
