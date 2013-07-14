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
    
    NSTimeInterval playStartTime;
    NSTimeInterval playPauseTime;
    bool playTimerRunning;
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
    if(!self.initialStartTime){
        self.initialStartTime = 15 * 60; // 15 minutes default
    }
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
    
    // play timer
    layer = [self.playContentView layer];
    [layer setCornerRadius:5.0f];
    [layer setBorderColor:[UIColor blackColor].CGColor];
    [layer setBorderWidth:1.0f];
    frame = self.playContentView.frame;
    frame.origin.x = self.contentView.frame.size.width - self.timerBorder.frame.size.width - self.playContentView.frame.size.width - 30;
    frame.origin.y = 3;
    self.playContentView.frame = frame;
    
    // initialize
    timerRunning = NO;
    playTimerRunning = NO;
    [self resetTimer:self];
    [self resetPlayTime:self];
}

- (IBAction)toggleStartStop:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"Timer - toggleStartStop"]];
    timerRunning = !timerRunning;
    if(!timerRunning){ // stop the timer
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        self.resetButton.enabled = YES;
        self.startButton.enabled = YES;
        pauseTime = [NSDate timeIntervalSinceReferenceDate];
    } else { // start the timer
        [self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
        self.resetButton.enabled = NO;
        if(startTime == self.initialStartTime){
            startTime = [NSDate timeIntervalSinceReferenceDate] + self.initialStartTime;
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
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"Timer - reset"]];
    
    if(timerRunning){
        [self toggleStartStop:nil];
    }
    self.resetButton.enabled = NO;
    startTime = self.initialStartTime;
    pauseTime = 0;
    [self setTimerLabelForInterval:startTime forLabel:self.timerLabel];
}

- (IBAction)changeTime:(id)sender {
    self.minutesTextField.alpha = 1;
    // todo
}

- (IBAction)togglePlayStartStop:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"Timer - toggleStartStop"]];
    playTimerRunning = !playTimerRunning;
    if(!playTimerRunning){ // stop the timer
        [self.playStartButton setTitle:@"Start" forState:UIControlStateNormal];
        self.playResetButton.enabled = YES;
        self.playStartButton.enabled = YES;
        playPauseTime = [NSDate timeIntervalSinceReferenceDate];
    } else { // start the timer
        [self.playStartButton setTitle:@"Pause" forState:UIControlStateNormal];
        self.playResetButton.enabled = NO;
        if(playStartTime == 15){
            playStartTime = [NSDate timeIntervalSinceReferenceDate] + 15;
        }
        if(playPauseTime > 0){ // account for pausing (stopping without resetting)
            NSTimeInterval pauseElapse = [NSDate timeIntervalSinceReferenceDate] - playPauseTime;
            playPauseTime = 0;
            playStartTime = playStartTime + pauseElapse;
        }
        [self updatePlayTime];
    }
}

- (void) updatePlayTime{
    if(!playTimerRunning){
        return;
    }
    // calculate elapsed time
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = playStartTime - currentTime;
    [self setTimerLabelForInterval:elapsed forLabel:self.playTimerLabel];
    if(elapsed >= 0){
        [self performSelector:@selector(updatePlayTime) withObject:self afterDelay:0.1];
    } else {
        self.playStartButton.enabled = NO;
        self.playResetButton.enabled = YES;
    }
}

- (void) updateTime{
    if(!timerRunning){
        return;
    }
    // calculate elapsed time
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = startTime - currentTime;
    [self setTimerLabelForInterval:elapsed forLabel:self.timerLabel];
    
    if(elapsed >= 0){
        [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
    } else {
        self.startButton.enabled = NO;
        self.resetButton.enabled = YES;
    }
}

- (void) setTimerLabelForInterval:(NSTimeInterval) timeInterval forLabel:(UILabel*)label{
    // calculate the seconds/minutes/hours
    int minutes = (int) timeInterval / 60;
    timeInterval = timeInterval - (minutes * 60);
    int seconds = (int) timeInterval;
    timeInterval = timeInterval - seconds;
    int fraction = timeInterval * 10;
    
    // update label
    label.text = [NSString stringWithFormat:@"%02u:%02u.%u", minutes, seconds, fraction];
}

- (IBAction)changePlayTime:(id)sender {
}

- (IBAction)resetPlayTime:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"Timer - reset play timer"]];
    
    if(playTimerRunning){
        [self togglePlayStartStop:nil];
    }
    self.playResetButton.enabled = NO;
    playStartTime = 15; // 15 seconds
    playPauseTime = 0;
    [self setTimerLabelForInterval:playStartTime forLabel:self.playTimerLabel];
}
@end
