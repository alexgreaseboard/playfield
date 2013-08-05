//
//  TimerView.h
//  PlayField
//
//  Created by Emily Jeppson on 3/30/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PurpleButton.h"

@interface TimerView : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet PurpleButton *changeButton;

@property (strong, nonatomic) IBOutlet PurpleButton *playStartButton;
@property (strong, nonatomic) IBOutlet PurpleButton *playResetButton;
@property (strong, nonatomic) IBOutlet UIView *playContentView;
@property (strong, nonatomic) IBOutlet UILabel *playTimerLabel;


@property (strong, nonatomic) IBOutlet UIView *timerBorder;

@property (nonatomic) NSTimeInterval initialStartTime;
@property (retain, nonatomic) UIViewController *parent;

- (IBAction)toggleStartStop:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)changeTime:(id)sender;

- (IBAction)togglePlayStartStop:(id)sender;
- (IBAction)resetPlayTime:(id)sender;

@end
