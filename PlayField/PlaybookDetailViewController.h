//
//  PlaybookDetailViewController.h
//  PlayField
//
//  Created by Jai on 3/14/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybookEditViewController.h"

@interface PlaybookDetailViewController : UIViewController <PlaybookEditDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) Playbook *playbook;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)returnToPlaybooks:(id)sender;

@end
