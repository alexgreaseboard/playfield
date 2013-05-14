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
#import "PlaybookPinchGestureRecognizer.h"

@interface PlaybookViewController : PlaybookPinchGestureRecognizer <UIAlertViewDelegate, UICollectionViewDelegateFlowLayout>

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)addPlaybook:(id)sender;

@end
