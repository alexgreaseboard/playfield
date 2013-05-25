//
//  PlaybookCell.h
//  PlayField
//
//  Created by Jai on 3/11/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playbook.h"

@interface PlaybookCell : UICollectionViewCell


- (id)initWithFrame:(CGRect)frame playbook:(Playbook*)playbook;
- (id)initWithFrame:(CGRect)frame name:(NSString*)name;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
