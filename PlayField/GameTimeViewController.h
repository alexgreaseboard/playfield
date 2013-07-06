//
//  GameTimeViewController.h
//  PlayField
//
//  Created by Emily Jeppson on 5/1/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybookDataSource.h"
#import "PlaybookPlayDataSource.h"
#import "UpcomingPlaysDataSource.h"
#import "PlaybookPinchGestureRecognizer.h"
#import "PurpleButton.h"
#import "TimerView.h"

@interface GameTimeViewController : PlaybookPinchGestureRecognizer<UIGestureRecognizerDelegate>

// outlets & actions
@property (strong, nonatomic) IBOutlet UIView *currentPlayView;
@property (strong, nonatomic) IBOutlet UIButton *nextPlayButton;
@property (strong, nonatomic) IBOutlet UIButton *removeAllButton;
@property (strong, nonatomic) IBOutlet UIButton *switchTypeButton;
@property (strong, nonatomic) IBOutlet TimerView *timerView;
@property (strong, nonatomic) IBOutlet PurpleButton *doneButton;

- (IBAction)close:(id)sender;
- (IBAction)loadNextPlay:(id)sender;
- (IBAction)removeAllPlays:(id)sender;
- (IBAction)switchType:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;



@property (strong, nonatomic) UpcomingPlaysDataSource *upcomingPlaysDS;

// gestures - pinching & panning
@property (nonatomic, strong) NSIndexPath *currentPannedItem;

// object context
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, strong) PlaybookPlay *currentPlay;

@end
