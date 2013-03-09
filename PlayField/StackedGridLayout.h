//
//  StackedGridLayout.h
//  Flicker Search
//
//  Created by Emily Jeppson on 2/14/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackedGridLayoutSection.h"

@protocol StackedGridLayoutDelegate <UICollectionViewDelegate>
// 1
- (NSInteger)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
   numberOfColumnsInSection:(NSInteger)section;
// 2
- (CGSize)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
    sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
// 3
- (UIEdgeInsets)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl
   itemInsetsForSectionAtIndex:(NSInteger)section;

- (NSInteger)findColumnForIndex:(NSInteger) index;
@end

@interface StackedGridLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat headerHeight;


@end
