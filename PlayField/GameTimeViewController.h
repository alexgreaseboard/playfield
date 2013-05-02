//
//  GameTimeViewController.h
//  PlayField
//
//  Created by Emily Jeppson on 5/1/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybookDataSource.h"

@interface GameTimeViewController : UIViewController
- (IBAction)close:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *playbooksCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *upcomingPlaysCollection;

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) PlaybookDataSource *playBookDS;
@end
