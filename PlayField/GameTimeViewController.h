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
#import "PlaybookPinchGestureRecognizer.h"
#import "PurpleButton.h"
#import "TimerView.h"
#import "PurpleLabel.h"

@interface GameTimeViewController : PlaybookPinchGestureRecognizer<UIGestureRecognizerDelegate>

// outlets & actions
@property (strong, nonatomic) IBOutlet UIView *currentPlayView;
@property (strong, nonatomic) IBOutlet UIButton *nextPlayButton;
@property (strong, nonatomic) IBOutlet UIButton *removeAllButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeButtons;
@property (strong, nonatomic) IBOutlet TimerView *timerView;
@property (strong, nonatomic) IBOutlet PurpleButton *doneButton;
@property (strong, nonatomic) IBOutlet PurpleLabel *upcomingPlaysLabel;
@property (strong, nonatomic) IBOutlet PurpleButton *gameButton;

@property (strong, nonatomic) IBOutlet UIView *scoreboardView;
@property (strong, nonatomic) IBOutlet UILabel *homeScoreLbl;
@property (strong, nonatomic) IBOutlet UILabel *awayScoreLbl;
@property (strong, nonatomic) IBOutlet UIStepper *homeScoreStepper;
@property (strong, nonatomic) IBOutlet UIStepper *awayScoreStepper;
@property (strong, nonatomic) IBOutlet UIButton *scoreboardButton;
@property (strong, nonatomic) IBOutlet UILabel *scoreboardLabel;
@property (strong, nonatomic) IBOutlet UILabel *homeTOLbl;
@property (strong, nonatomic) IBOutlet UILabel *awayTOLbl;
@property (strong, nonatomic) IBOutlet UIStepper *homeTOStepper;
@property (strong, nonatomic) IBOutlet UIStepper *awayTOStepper;
@property (strong, nonatomic) IBOutlet UILabel *scoresLbl;

@property (strong, nonatomic) PlaybookPlayDataSource *upcomingPlaysDS;

// gestures - pinching & panning
@property (nonatomic, strong) NSIndexPath *currentPannedItem;

// object context
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) PlaybookPlay *currentPlay;

- (IBAction)close:(id)sender;
- (IBAction)loadNextPlay:(id)sender;
- (IBAction)removeAllPlays:(id)sender;
- (IBAction)switchType:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)toggleGame:(id)sender;
- (IBAction)changeScore:(id)sender;
- (IBAction)toggleScoreboard:(id)sender;
- (IBAction)resetScoreboard:(id)sender;
- (IBAction)changeTimeouts:(id)sender;
@end
