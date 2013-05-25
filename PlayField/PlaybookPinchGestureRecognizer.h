//
//  PlaybookPinchGestureRecognizer.h
//  PlayField
//
//  Created by Emily Jeppson on 5/11/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybookDataSource.h"
#import "PlaysDataSource.h"

@interface PlaybookPinchGestureRecognizer : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *collectionLabel;
@property (strong, nonatomic) NSString *offenseOrDefense;

// collections
@property (strong, nonatomic) IBOutlet UICollectionView *playbooksCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *playsCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *upcomingPlaysCollection;
@property (strong, nonatomic) PlaybookDataSource *playBookDS;
@property (strong, nonatomic) PlaysDataSource *playsDS;

// gestures - pinching & panning
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchOutGestureRecognizer;
@property (nonatomic, strong) NSIndexPath *currentPinchedItem;
@property (nonatomic, strong) UIPanGestureRecognizer *reorderGestureRecognizer;

- (void)handlePinchInGesture: (UIPinchGestureRecognizer*)recognizer;
- (void)handlePinchOutGesture: (UIPinchGestureRecognizer*)recognizer;

@end
