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

- (IBAction)savePlay:(id)sender {
    [self.delegate savePlayViewController:self];
}

- (IBAction)saveDuplicate:(id)sender {
    [self.delegate saveDuplicatePlayViewController:self];
}

- (IBAction)saveReverse:(id)sender {
    [self.delegate saveReversePlayViewController:self];
}

@end
