//
//  PlaybookCell.h
//  PlayField
//
//  Created by Jai on 3/11/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybookPlay.h"

@interface PlaybookPlayCell : UICollectionViewCell

- (void) highlightCell;
- (void) unhighlightCell;
-(void) configureCell:(PlaybookPlay*)pPlaybookPlay;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) Boolean *isHover;
@property (strong, nonatomic) PlaybookPlay *playbookPlay;

@end
