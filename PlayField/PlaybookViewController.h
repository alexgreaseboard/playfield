//
//  PlaybookDetailsViewController.h
//  PlayField
//
//  Created by Jai Lebo on 3/7/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbook.h"
#import "PlaybookDataSource.h"

@interface PlaybookViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) PlaybookDataSource *playBookDS;

- (IBAction)addPlaybook:(id)sender;

@end
