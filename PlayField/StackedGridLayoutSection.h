//
//  StackedGridLayoutSection.h
//  Flicker Search
//
//  Created by Emily Jeppson on 2/14/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackedGridLayoutSection : NSObject
@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, assign, readonly) UIEdgeInsets itemInsets;
@property (nonatomic, assign, readonly) NSInteger numberOfItems;

- (id)initWithOrigin:(CGPoint)origin
                width:(CGFloat)width
                columns:(NSInteger)columns
                itemInsets:(UIEdgeInsets)itemInsets;


- (void)addItemToColumn:(CGSize)size
               forIndex:(NSInteger)index
              forColumn:(NSInteger) columnIndex;

- (CGRect)frameForItemAtIndex:(NSInteger)index;

- (CGFloat) widthForItemAtColumnIndex:(NSInteger) columnIndex;

@end