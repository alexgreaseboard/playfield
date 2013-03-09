//
//  SavePlayViewController.h
//  PlayField
//
//  Created by Jai on 2/27/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocosViewController.h"

@interface SavePlayViewController : UIViewController

@property (nonatomic, strong) CocosViewController *cocosViewController;

- (IBAction)savePlay:(id)sender;
- (IBAction)saveDuplicate:(id)sender;
- (IBAction)saveReverse:(id)sender;

@end
