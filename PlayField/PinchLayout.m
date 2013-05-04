//
//  PinchLayout.m
//  PlayField
//
//  Created by Emily Jeppson on 5/2/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PinchLayout.h"

@implementation PinchLayout

- (UICollectionViewLayoutAttributes*) layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applySettingsToAttributes:attributes];
    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect { // 1
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    // 2
    [layoutAttributes enumerateObjectsUsingBlock: ^(UICollectionViewLayoutAttributes *attributes,
                                                    NSUInteger idx, BOOL *stop){
     [self applySettingsToAttributes:attributes];
     }];
    // 3
    return layoutAttributes;
}

- (void)applySettingsToAttributes: (UICollectionViewLayoutAttributes*)attributes
{
    // 1
    NSIndexPath *indexPath = attributes.indexPath;
    attributes.zIndex = -indexPath.item;
    // 2
    CGFloat deltaX = self.pinchCenter.x - attributes.center.x;
    CGFloat deltaY = self.pinchCenter.y - attributes.center.y;
    CGFloat scale = 1.0f - self.pinchScale;
    // 3
    CATransform3D transform = CATransform3DMakeTranslation(deltaX * scale,
                                                           deltaY * scale,
                                                           0.0f);
    attributes.transform3D = transform;
}

- (void)setPinchScale:(CGFloat)pinchScale {
    _pinchScale = pinchScale;
    [self invalidateLayout];
}
- (void)setPinchCenter:(CGPoint)pinchCenter {
    _pinchCenter = pinchCenter;
    [self invalidateLayout];
}

@end
