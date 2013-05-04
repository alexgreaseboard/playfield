//
//  UpcomingPlaysDataSource.h
//  PlayField
//
//  Created by Emily Jeppson on 5/4/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingPlaysDataSource : NSObject<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *upcomingPlays;

@end
