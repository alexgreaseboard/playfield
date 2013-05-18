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

@interface PlaybookDetailViewController : UIViewController <PlaybookEditDelegate,UIAlertViewDelegate,PlayCreationPlaysDelegate,UICollectionViewDelegate>

@property (nonatomic, strong) Playbook *playbook;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


- (IBAction)returnToPlaybooks:(id)sender;

@end
