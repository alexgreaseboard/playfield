//
//  PlayDrillItem.h
//  GreaseBoard
//
//  Created by Jai Lebo on 2/9/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayDrillItem : NSObject

// A text description of this item.
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) UIImage *image;

// Returns an SHCToDoItem item initialized with the given text.
-(id)initWithText:(NSString*)text andWithImage:(NSString *)image;

// Returns an SHCToDoItem item initialized with the given text.
+(id)itemWithText:(NSString*)text andWithImage:(NSString *)image;

@end
