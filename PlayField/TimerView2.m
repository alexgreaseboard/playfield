//
//  TimerView.m
//  PlayField
//
//  Created by Emily Jeppson on 3/30/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "TimerView2.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimerView2{
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
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"TimerView2" owner:self options:nil] objectAtIndex:0];
    [self addSubview:self.contentView];
    [self setupUI];
    
    // initialize
    timerRunning = NO;
    [self resetTimer:self];
}

- (IBAction)toggleStartStop:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"Timer - toggleStartStop"]];
    timerRunning = !timerRunning;
    if(!timerRunning){ // stop the timer
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        self.resetButton.enabled = YES;
        pauseTime = [NSDate timeIntervalSinceReferenceDate];
    } else { // start the timer
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.resetButton.enabled = NO;
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

- (void) setupUI{
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
    
    // add a shine to the background
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.2f],
                            nil];
    shineLayer.frame = frame;
    [self.contentView.layer insertSublayer:shineLayer above:self.contentView.layer];
    
    //move to the far right & add border
    CALayer *layer = [self.timerBorder layer];
    [layer setCornerRadius:5.0f];
    [layer setBorderColor:[UIColor blackColor].CGColor];
    [layer setBorderWidth:1.0f];
    frame = self.timerBorder.frame;
    frame.origin.x = self.contentView.frame.size.width - self.timerBorder.frame.size.width - 10;
    frame.origin.y = 3;
    self.timerBorder.frame = frame;
    self.timerLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}


- (IBAction)resetTimer:(id)sender {
    [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"Timer - reset"]];
    self.resetButton.enabled = NO;
    self.timerLabel.text = @"00:00";
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
    int minutes = (int) elapsed / 60;
    elapsed = elapsed - (minutes * 60);
    int seconds = (int) elapsed;
    elapsed = elapsed - seconds;
    
    // update label
    self.timerLabel.text = [NSString stringWithFormat:@"%02u:%02u", minutes, seconds];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.2];
}

@end
