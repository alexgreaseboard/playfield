//
//  TimerView.m
//  PlayField
//
//  Created by Emily Jeppson on 3/30/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "TimerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimerView{
    NSTimeInterval startTime;
    NSTimeInterval pauseTime;
    bool timerRunning;
}

- (id)initWithFrame:(CGRect)aRect{
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
    CGRect frame = self.superview.frame;
    frame.size.height = 49;
    frame.origin.y = self.superview.frame.size.height - 49;
    self.frame = frame;
    
    frame = self.frame;
    frame.origin.y = 0;
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
}

- (IBAction)toggleStartStop:(id)sender {
    timerRunning = !timerRunning;
    if(!timerRunning){ // stop the timer
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        self.resetButton.enabled = YES;
        self.resetButton.alpha = 1.0;
        pauseTime = [NSDate timeIntervalSinceReferenceDate];
    } else { // start the timer
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.resetButton.enabled = NO;
        self.resetButton.alpha = 0.8f;
        if(startTime == 0){
            startTime = [NSDate timeIntervalSinceReferenceDate];
        }
        if(pauseTime > 0){ // account for pausing (stopping without resetting)
            NSTimeInterval pauseElapse = [NSDate timeIntervalSinceReferenceDate] - pauseTime;
            pauseTime = 0;
            startTime = startTime + pauseElapse;
        }
        [self updateTime];
    }
}


- (IBAction)resetTimer:(id)sender {
    self.resetButton.enabled = NO;
    self.resetButton.alpha = 0.8f;
    self.timerLabel.text = @"00:00:00.0";
    startTime = 0;
    pauseTime = 0;
}

- (void) updateTime{
    if(!timerRunning){
        return;
    }
    // calculate elapsed time
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - startTime;
    
    // calculate the seconds/minutes/hours
    int hours = (int) elapsed / 60 / 60;
    elapsed = elapsed - (hours * 60 * 60);
    int minutes = (int) elapsed / 60;
    elapsed = elapsed - (minutes * 60);
    int seconds = (int) elapsed;
    elapsed = elapsed - seconds;
    int fraction = elapsed * 10;
    
    // update label
    self.timerLabel.text = [NSString stringWithFormat:@"%02u:%02u:%02u.%u", hours, minutes, seconds, fraction];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

@end
