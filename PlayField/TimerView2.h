//
//  TimerView.h
//  PlayField
//
//  Created by Emily Jeppson on 3/30/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PurpleButton.h"
#import <UIKit/UIKit.h>

@interface TimerView2 : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet PurpleButton *startButton;
@property (strong, nonatomic) IBOutlet PurpleButton *resetButton;
@property (strong, nonatomic) IBOutlet UIView *timerBorder;

- (IBAction)toggleStartStop:(id)sender;
- (IBAction)resetTimer:(id)sender;

@end
