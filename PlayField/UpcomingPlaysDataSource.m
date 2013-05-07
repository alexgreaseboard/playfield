//
//  UpcomingPlaysDataSource.m
//  PlayField
//
//  Created by Emily Jeppson on 5/4/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "UpcomingPlaysDataSource.h"
#import "PlaybookCell.h"
#import "Play.h"

@implementation UpcomingPlaysDataSource

- (id) init{
    if((self=[super init])){
        self.upcomingPlays = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"Upcoming plays size: %d", self.upcomingPlays.count);
    return self.upcomingPlays.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO custom PlayCell??
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PlayCell" forIndexPath:indexPath];
    
    PlaybookCell *playbookCell = (PlaybookCell *) cell;
    Play *play = [self.upcomingPlays objectAtIndex:indexPath.item];
    playbookCell = [playbookCell initWithFrame:playbookCell.frame name:play.name];
    return playbookCell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(150, 150);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
