//
//  PlaybookPinchGestureRecognizer.m
//  PlayField
//
//  Created by Emily Jeppson on 5/11/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookPinchGestureRecognizer.h"
#import "PinchLayout.h"
#import "PlaybookPlayCell.h"
#import "CocosViewController.h"
#import "PlaybookPlay.h"

static const CGFloat kMinScale = 1.0f;
static const CGFloat kMaxScale = 3.0f;

@implementation PlaybookPinchGestureRecognizer{
    PlaybookPlay *selectedPlaybookplay;
}

// Pinch out - show the plays, hide the playbooks
- (void)handlePinchOutGesture: (UIPinchGestureRecognizer*)recognizer
{
    // begin pinching
     //NSLog(@"Pinching");
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookPinch - Begin pinching out"]];
        // get the pinch point in the play books collection
        CGPoint pinchPoint = [recognizer locationInView:self.playbooksCollection];
        NSIndexPath *pinchedItem = [self.playbooksCollection indexPathForItemAtPoint:pinchPoint];
        if (pinchedItem) { 
            self.currentPinchedItem = pinchedItem;
            PinchLayout *layout = [[PinchLayout alloc] init];
            layout.itemSize = CGSizeMake(200.0f, 200.0f);
            layout.minimumInteritemSpacing = 20.0f;
            layout.minimumLineSpacing = 20.0f;
            layout.sectionInset = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
            layout.headerReferenceSize = CGSizeMake(0.0f, 90.0f);
            layout.pinchScale = 0.0f;
            
            self.playsCollection = [[UICollectionView alloc]
                                    initWithFrame:self.playbooksCollection.frame collectionViewLayout:layout];
            self.playsCollection.backgroundColor = [UIColor clearColor];
            self.playsCollection.delegate = self;
            self.playsCollection.dataSource = self.playbookPlayDS;
            self.playsCollection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.playsCollection.backgroundColor = [UIColor clearColor];
            self.playsCollection.scrollEnabled = YES;
            Playbook *playbook = [self.playBookDS.fetchedResultsController objectAtIndexPath:self.currentPinchedItem];
            self.playbookPlayDS.playbook = playbook;
            
            [self.playsCollection registerClass:[PlaybookPlayCell class] forCellWithReuseIdentifier:@"PlaybookPlayCell"];
            [self.view addSubview:self.playsCollection];
            
            
            if(self.collectionLabel){
                // gestures - pinch to close
                UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchInGesture:)];
                recognizer.delegate = self;
                [self.playsCollection addGestureRecognizer:recognizer];
                
                // gestures - drag & drop
                UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlayPanning:)];
                panRecognizer.delegate = self;
                [self.playsCollection addGestureRecognizer:panRecognizer];
            }
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.currentPinchedItem) {
            CGFloat theScale = recognizer.scale;
            theScale = MIN(theScale, kMaxScale);
            theScale = MAX(theScale, kMinScale);
            CGFloat theScalePct = (theScale - kMinScale) / (kMaxScale - kMinScale);
            
            PinchLayout *layout = (PinchLayout*)_playsCollection.collectionViewLayout;
            layout.pinchScale = theScalePct; layout.pinchCenter =
            [recognizer locationInView:self.playsCollection];
            // fade out the playbooks collection
            self.playbooksCollection.alpha = 1.0f - theScalePct; }
    } else {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookPinch - pinching out ended"]];
        if (self.currentPinchedItem) {
            Playbook *playbook = [self.playBookDS.fetchedResultsController objectAtIndexPath:self.currentPinchedItem];
            if(self.collectionLabel){
                self.collectionLabel.text = [NSString stringWithFormat:@"%@ Plays for %@",self.offenseOrDefense, playbook.name];
            }
            // hide the old collection
            PinchLayout *layout = (PinchLayout*)_playsCollection.collectionViewLayout;
            layout.pinchScale = 1.0f;
            self.playbooksCollection.alpha = 0.0f; }
    }
}

// hide the plays, show the playbooks
- (void)handlePinchInGesture: (UIPinchGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookPinch - begin pinch in"]];
        self.playbooksCollection.alpha = 0.0f;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat theScale = 1.0f / recognizer.scale;
        theScale = MIN(theScale, kMaxScale);
        theScale = MAX(theScale, kMinScale);
        CGFloat theScalePct = 1.0f - ((theScale - kMinScale) / (kMaxScale - kMinScale));
        PinchLayout *layout = (PinchLayout*)self.playsCollection.collectionViewLayout ;
        layout.pinchScale = theScalePct;
        layout.pinchCenter = [recognizer locationInView:self.playbooksCollection];
        self.playbooksCollection.alpha = 1.0f - theScalePct;
    } else {
        [TestFlight passCheckpoint:[NSMutableString stringWithFormat:@"PlaybookPinch - end pinch in"]];
        self.collectionLabel.text = [NSString stringWithFormat:@"%@ Playbooks", self.offenseOrDefense];
        self.playbooksCollection.alpha = 1.0f;
        [self.playsCollection removeFromSuperview];
        self.playsCollection = nil;
        self.currentPinchedItem = nil;
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedPlaybookplay = [self.playbookPlayDS.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"playbookPlayDetailSegue" sender:selectedPlaybookplay];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playbookPlayDetailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CocosViewController *controller = (CocosViewController *) navigationController;
        [controller setCurrentPlay:selectedPlaybookplay.play];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.playBookDS collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [self.playBookDS collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
}


@end
