//
//  StackedGridLayoutSection.m
//  Flicker Search
//
//  Created by Emily Jeppson on 2/14/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import "StackedGridLayoutSection.h"

@implementation StackedGridLayoutSection{
    CGRect _frame;
    UIEdgeInsets _itemInsets;
    CGFloat _evenColumnWidth; // times
    CGFloat _oddColumnWidth; // column values
    NSMutableArray *_columnHeights;
    NSMutableDictionary *_indexToFrameMap;
}

- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width
             columns:(NSInteger)columns itemInsets:(UIEdgeInsets)itemInsets
{
    if ((self = [super init])) {
        _frame = CGRectMake(origin.x, origin.y, width, 0.0f);
        _itemInsets = itemInsets;
        CGFloat twoColumnWidth = floorf(width * 2 / columns );
        //NSLog(@"Two column width: %f", twoColumnWidth);
        _evenColumnWidth = 30;
        _oddColumnWidth = twoColumnWidth - _evenColumnWidth;
        _columnHeights = [NSMutableArray new];
        _indexToFrameMap = [NSMutableDictionary new];
        for (NSInteger i = 0; i < columns; i++) {
            [_columnHeights addObject:@(0.0f)];
        }
    }
    return self;
}

- (CGRect)frame {
    return _frame;
}
- (NSInteger)numberOfItems {
    return _indexToFrameMap.count;
}

- (CGFloat) widthForItemAtColumnIndex:(NSInteger) columnIndex{
    CGFloat _columnWidth = _evenColumnWidth;
    if( columnIndex % 2 == 1){
        _columnWidth = _oddColumnWidth;
    }
    return _columnWidth;
}

- (void)addItemToColumn:(CGSize)size forIndex:(NSInteger)index forColumn:(NSInteger) columnIndex
{
    // find the column height
    __block CGFloat columnHeight = CGFLOAT_MAX;
    // 2
    [_columnHeights enumerateObjectsUsingBlock: ^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        CGFloat thisColumnHeight = [height floatValue];
        if (idx == columnIndex) {
            columnHeight = thisColumnHeight;
        }
    }];
    // 3
    CGRect frame;
    //CGFloat _columnWidth = [self widthForItemAtColumnIndex:columnIndex];
     //NSLog(@"Adding item to column %d width: %f", columnIndex, _evenColumnWidth);
    
    if(columnIndex % 2 == 0){
        frame.origin.y = _frame.origin.y + columnHeight + _itemInsets.top - 5;
        if(columnIndex == 0){
            frame.origin.x = _frame.origin.x + ((_evenColumnWidth + _oddColumnWidth) * (columnIndex)) + _itemInsets.left;
        } else{
            frame.origin.x = _frame.origin.x + ((_evenColumnWidth + _oddColumnWidth) * (columnIndex/2)) + _itemInsets.left;
        }
    } else{
        frame.origin.y = _frame.origin.y + columnHeight + _itemInsets.top;
        if(columnIndex == 1) {
            frame.origin.x = _frame.origin.x + _evenColumnWidth + _itemInsets.left;
        } else{
            frame.origin.x = _frame.origin.x + ((_evenColumnWidth + _oddColumnWidth) * (columnIndex/2)) + _evenColumnWidth + _itemInsets.left;
        }
        //CGFloat previousColumnWidth = (_evenColumnWidth + _oddColumnWidth) * (columnIndex-1);
        //frame.origin.x = _frame.origin.x + ((_evenColumnWidth + _oddColumnWidth) * (columnIndex-2)) + (_evenColumnWidth * columnIndex) + _itemInsets.left;
    }
    
    //NSLog(@"Adding item to column %d x: %f y: %f", columnIndex, frame.origin.x, frame.origin.y);
    frame.size = size;
    // 4
    _indexToFrameMap[@(index)] = [NSValue valueWithCGRect:frame];
    // 5
    if (CGRectGetMaxY(frame) > CGRectGetMaxY(_frame)) { _frame.size.height =
        (CGRectGetMaxY(frame) - _frame.origin.y) + _itemInsets.bottom;
    }
    // 6
    [_columnHeights replaceObjectAtIndex:columnIndex
                              withObject:@(columnHeight + size.height +
     _itemInsets.bottom)];
}

- (CGRect)frameForItemAtIndex:(NSInteger)index {
    return [_indexToFrameMap[@(index)] CGRectValue];
}
@end
