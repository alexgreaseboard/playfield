//
//  PinchLayout.h
//  PlayField
//
//  Created by Emily Jeppson on 5/2/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinchLayout : UICollectionViewFlowLayout

// keep track of the center of the pinch
@property (nonatomic, assign) CGFloat pinchScale;
@property (nonatomic, assign) CGPoint pinchCenter;

@end
