//
//  PlaybookPinchGestureRecognizer.m
//  PlayField
//
//  Created by Emily Jeppson on 5/11/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import "PlaybookPinchGestureRecognizer.h"
#import "PinchLayout.h"
#import "PlaybookCell.h"

static const CGFloat kMinScale = 1.0f;
static const CGFloat kMaxScale = 3.0f;

@implementation PlaybookPinchGestureRecognizer

// Pinch out - show the plays, hide the playbooks
- (void)handlePinchOutGesture: (UIPinchGestureRecognizer*)recognizer
{
    // begin pinching
     //NSLog(@"Pinching");
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"Begin pinching");
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
            // todo pass in the selected playbook
            self.playsCollection.delegate = self.playsDS;
            self.playsCollection.dataSource = self.playsDS;
            self.playsCollection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.playsCollection.backgroundColor = [UIColor clearColor];
            self.playsCollection.scrollEnabled = YES;
            Playbook *playbook = [self.playBookDS.fetchedResultsController objectAtIndexPath:self.currentPinchedItem];
            self.playsDS.playbook = playbook;
            
            [self.playsCollection registerClass:[PlaybookCell class] forCellWithReuseIdentifier:@"PlayCell"];
            [self.view addSubview:self.playsCollection];
            // gestures - pinch to close
            UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchInGesture:)];
            recognizer.delegate = self;
            [self.playsCollection addGestureRecognizer:recognizer];
            // gestures - drag & drop
            // gestures - drag
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlayPanning:)];
            panRecognizer.delegate = self;
            [self.playsCollection addGestureRecognizer:panRecognizer];
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
        //NSLog(@"Pinching ended");
        if (self.currentPinchedItem) {
            Playbook *playbook = [self.playBookDS.fetchedResultsController objectAtIndexPath:self.currentPinchedItem];
            // TODO Fix the label
            //self.collectionLabel.text = [NSString stringWithFormat:@"%@ Plays for %@",self.offenseOrDefense, playbook.name];
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
        self.collectionLabel.text = [NSString stringWithFormat:@"%@ Playbooks", self.offenseOrDefense];
        self.playbooksCollection.alpha = 1.0f;
        [self.playsCollection removeFromSuperview];
        self.playsCollection = nil;
        self.currentPinchedItem = nil;
    }
}


@end
