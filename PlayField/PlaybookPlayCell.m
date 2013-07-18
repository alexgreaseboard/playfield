//
//  PlaybookPlayCell.m
//  PlayField
//
//  Created by Emily Jeppson on 5/25/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookPlayCell.h"
#import "Play.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlaybookPlayCell {
    PlaybookPlay *playbookPlay;
    CAGradientLayer *disabledLayer;
}

- (id)initWithFrame:(CGRect)frame name:(NSString*)name {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //remove the label or you'll get 'ghost' labels
        UIView *foundLabel = [self viewWithTag:57];
        if (foundLabel) [foundLabel removeFromSuperview];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"football-texture.jpg"]];
        CALayer *layer = [self layer];
        [layer setCornerRadius:5.0f];
        [layer setBorderColor:[UIColor blackColor].CGColor];
        [layer setBorderWidth:1.0f];
        
        // add the label
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                   frame.size.width, 30)];
        self.nameLabel.textColor = [UIColor lightTextColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = [UIColor lightTextColor];
        self.nameLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.65];
        
        self.nameLabel.tag=57;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        self.nameLabel.text = [NSString stringWithFormat:@"  %@", name];
        self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.nameLabel];
        
        if(playbookPlay != nil && playbookPlay.play.thumbnail != nil) {
            [self addPlaysInformation];
        } else {
            self.backgroundColor = [UIColor grayColor];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame playbookPlay:(PlaybookPlay*)pPlaybookPlay
{
    playbookPlay = pPlaybookPlay;
    Play *play = playbookPlay.play;
    self = [self initWithFrame:frame name:play.name];
    return self;
}

- (void) addPlaysInformation {
    // create the thumbnail
    UIImage *playImage = [UIImage imageWithData:playbookPlay.play.thumbnail];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView = [[UIImageView alloc] initWithImage:playImage];
}

- (void) highlightCell {
    if(!disabledLayer){
        [disabledLayer removeFromSuperlayer];
        disabledLayer = [CAGradientLayer layer];
        disabledLayer.colors = [NSArray arrayWithObjects:
                             (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:0.05f].CGColor,
                             (id)[UIColor colorWithWhite:0.75f alpha:0.8f].CGColor,
                             nil];
        disabledLayer.locations = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.2f],
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
