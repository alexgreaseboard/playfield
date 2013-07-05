//
//  CocosViewController.h
//  PlayField
//
//  Created by Jai Lebo on 2/16/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "PlayCreationDetailsViewController.h"
#import "Play.h"
#import "SavePlayViewController.h"
#import "PlayCreationPlaysTableViewController.h"
#import "PlayCreationItemsTableViewController.h"
#import "HelloWorldLayer.h"

@class CocosViewController;

@interface CocosViewController : UIViewController <CCDirectorDelegate,PlayCreationDetailsViewControllerDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate,SavePlayViewControllerDelegate>

@property (strong, nonatomic) Play *detailItem;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) HelloWorldLayer *helloWorldLayer;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *notes;

- (IBAction)saveButtonPressed:(id)sender;

- (void)savePlay:(id)sender;
- (void)setCurrentPlay:(Play *)pPlay;
- (void)addItemSprite:(NSString *)itemName;
- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
