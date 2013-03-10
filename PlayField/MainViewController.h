//
//  MainViewController.h
//  GreaseBoard
//
//  Created by Jai Lebo on 2/2/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)showRoster:(id)sender;
- (IBAction)showPlaysDrills:(id)sender;
- (IBAction)showPlaybook:(id)sender;
- (IBAction)showPractices:(id)sender;

@end
