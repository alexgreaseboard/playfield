//
//  PlaybookCell.m
//  PlayField
//
//  Created by Jai on 3/11/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookCell.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@implementation PlaybookCell {
    Playbook *playbook;
    CAGradientLayer *disabledLayer;
}

- (id)initWithFrame:(CGRect)frame name:(NSString*)name {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //remove the label or you'll get 'ghost' labels
        UIView *foundLabel = [self viewWithTag:57];
        if (foundLabel) [foundLabel removeFromSuperview];
        
        //self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"football-texture.jpg"]];
        CALayer *layer = [self layer];
        [layer setCornerRadius:5.0f];
        [layer setBorderColor:[UIColor blackColor].CGColor]; // purple
        [layer setBorderWidth:1.0f];
        
        // add the label
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                   frame.size.width, 20)];
        self.nameLabel.textColor = [UIColor lightTextColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = [UIColor lightTextColor];
        self.nameLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.65];
        
        self.nameLabel.tag=57;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.nameLabel.text = [NSString stringWithFormat:@"  %@", name];
        self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.nameLabel];
        
        if(playbook != nil) {
            [self addPlaysInformation];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame playbook:(Playbook*)pPlaybook
{
    playbook = pPlaybook;
    self = [self initWithFrame:frame name:playbook.name];
    
    //remove the label or you'll get 'ghost' labels
    UIView *foundLabel = [self viewWithTag:58];
    if (foundLabel) [foundLabel removeFromSuperview];
    foundLabel = [self viewWithTag:59];
    if (foundLabel) [foundLabel removeFromSuperview];
    
    // add the type label
    UILabel *offenseDefenseLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLabel.frame.size.height,
                                                               frame.size.width, 20)];
    offenseDefenseLbl.textColor = [UIColor lightTextColor];
    offenseDefenseLbl.textAlignment = NSTextAlignmentLeft;
    offenseDefenseLbl.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.65];
    
    offenseDefenseLbl.tag=58;
    offenseDefenseLbl.font = [UIFont boldSystemFontOfSize:14.0];
    offenseDefenseLbl.text = [NSString stringWithFormat:@"  %@", playbook.type];
    offenseDefenseLbl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    offenseDefenseLbl.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:offenseDefenseLbl];
    
    
    // add the label
    UILabel *numPlaysLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLabel.frame.size.height + offenseDefenseLbl.frame.size.height,
                                                                           frame.size.width, 20)];
    numPlaysLbl.textColor = [UIColor lightTextColor];
    numPlaysLbl.textAlignment = NSTextAlignmentLeft;
    numPlaysLbl.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.65];
    
    numPlaysLbl.tag=59;
    numPlaysLbl.font = [UIFont boldSystemFontOfSize:14.0];
    numPlaysLbl.text = [NSString stringWithFormat:@"  %d Plays", playbook.playbookplays.count];
    numPlaysLbl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    numPlaysLbl.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:numPlaysLbl];
    return self;
}

- (void) addPlaysInformation {
    
}

- (void) highlightCell {
    if(!disabledLayer){
        [disabledLayer removeFromSuperlayer];
        disabledLayer = [CAGradientLayer layer];
        disabledLayer.colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                                (id)[UIColor colorWithWhite:1.0f alpha:0.01f].CGColor,
                                (id)[UIColor colorWithWhite:0.75f alpha:0.5f].CGColor,
                                nil];
        disabledLayer.locations = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:0.0f],
                                   [NSNumber numberWithFloat:0.6f],
                                   [NSNumber numberWithFloat:0.9f],
                                   nil];
        disabledLayer.frame = self.layer.bounds;
        [self.layer insertSublayer:disabledLayer above:self.layer];
    }
    disabledLayer.hidden = NO;
}

- (void) unhighlightCell {
    [disabledLayer removeFromSuperlayer];
    disabledLayer = nil;
}

@end
