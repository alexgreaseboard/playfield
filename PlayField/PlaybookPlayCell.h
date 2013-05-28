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


- (id)initWithFrame:(CGRect)frame playbookPlay:(PlaybookPlay*)playbookPlay;
- (id)initWithFrame:(CGRect)frame name:(NSString*)name;

- (void) highlightCell;
- (void) unhighlightCell;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) Boolean *isHover;

@end
