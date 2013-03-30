//
//  TimerView.h
//  PlayField
//
//  Created by Emily Jeppson on 3/30/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stepper;
@property (strong, nonatomic) IBOutlet UIView *timerBorder;

- (IBAction)toggleStartStop:(id)sender;
- (IBAction)resetTimer:(id)sender;

/*
 //override the frame so this component is always fills the bottom of the screen
 CGRect frame = self.superview.frame;
 frame.size.height = 49;
 frame.size.width = self.superview.frame.size.width;
 frame.origin.y = self.superview.frame.size.height - 49;
 self = [super initWithFrame:frame];
 return self;
 }
 
 - (void)awakeFromNib
 {
 self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"TimerView" owner:self options:nil] objectAtIndex:0];
 [self addSubview:self.contentView];
 // set the background
 self.backgroundColor = [UIColor clearColor];
 self.contentView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.65];
 
 // set the frame
 CGRect frame = self.frame;
 frame.size.height = 49;
 frame.size.width = self.superview.frame.size.width;
 frame.origin.y = self.superview.frame.size.height;
 self.contentView.frame = frame;
 
 //move to the far right & add border
 CALayer *layer = [self.timerBorder layer];
 [layer setCornerRadius:5.0f];
 [layer setBorderColor:[UIColor blackColor].CGColor];
 [layer setBorderWidth:1.0f];
 frame = self.timerBorder.frame;
 frame.origin.x = self.contentView.frame.size.width - self.timerBorder.frame.size.width - 10;
 frame.origin.y = 3;
 self.timerBorder.frame = frame;
 
 // initialize
 timerRunning = NO;
 [self resetTimer:self];
 */
@end
