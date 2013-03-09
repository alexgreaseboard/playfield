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

@interface ViewController : UIViewController<PracticeItemControllerDelegate, PracticeColumnEditControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
