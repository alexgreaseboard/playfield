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

@class CocosViewController;

@interface CocosViewController : UIViewController <CCDirectorDelegate,PlayCreationDetailsViewControllerDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Play *detailItem;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *notes;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)savePlay:(id)sender;
- (IBAction)saveDuplicate:(id)sender;
- (IBAction)saveReverse:(id)sender;
- (void)setCurrentPlay:(Play *)pPlay;
- (void)addItemSprite:(NSString *)itemName;

@end
