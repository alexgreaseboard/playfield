//
//  ViewController.h
//  Flicker Search
//
//  Created by Emily Jeppson on 2/13/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeItemEditController.h"
#import "PracticeColumnEditController.h"
#import "Practice.h"
#import "PlayCreationPlaysTableViewController.h"
#import "PracticeEditViewController.h"

@interface PracticeViewController : UIViewController<PracticeItemControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, PlayCreationPlaysDelegate, PracticeColumnEditControllerDelegate, PracticeEditControllerDelegate>

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Practice *practice;

- (IBAction)editPractice:(id)sender;
-(void)resetViewWithPractice:(Practice*)practice;
@end
