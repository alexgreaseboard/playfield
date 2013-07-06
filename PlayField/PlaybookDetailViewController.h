//
//  PlaybookDetailViewController.h
//  PlayField
//
//  Created by Jai on 3/14/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybookEditViewController.h"
#import "PlayCreationPlaysTableViewController.h"
#import "PlaybookViewController.h"

@interface PlaybookDetailViewController : UIViewController <PlaybookEditDelegate,UIAlertViewDelegate,PlayCreationPlaysDelegate,UICollectionViewDelegate>

@property (nonatomic, strong) Playbook *playbook;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) PlaybookViewController *parent;
@property (strong, nonatomic) IBOutlet UIImageView *trashCan;
@property (strong, nonatomic) IBOutlet UIView *mainView;

- (IBAction)returnToPlaybooks:(id)sender;


@end
