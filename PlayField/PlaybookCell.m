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
        [layer setBorderColor:[UIColor colorWithRed:.20 green:.15 blue:.33 alpha:0.99].CGColor]; // purple
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
    
    return self;
}

- (void) addPlaysInformation {
    
}

- (void) highlightCell {
    self.backgroundColor = [UIColor blueColor];
}

- (void) unhighlightCell {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"football-texture.jpg"]];
}

@end
