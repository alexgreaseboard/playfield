//
//  PlayDrillItem.m
//  GreaseBoard
//
//  Created by Jai Lebo on 2/9/13.
//  Copyright (c) 2013 GreaseBoard. All rights reserved.
//

#import "PlayDrillItem.h"

@implementation PlayDrillItem

-(id)initWithText:(NSString*)text andWithImage:(NSString *)imageName {
    if (self = [super init]) {
        self.text = text;
        self.imageName = imageName;
        self.image = [UIImage imageNamed:imageName];
    }
    return self;
}

+(id)itemWithText:(NSString *)text andWithImage:(NSString *)imageName {
    
    return [[PlayDrillItem alloc] initWithText:text andWithImage:imageName];
}

@end
