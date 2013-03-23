//
//  PracticeOptionsController.h
//  Flicker Search
//
//  Created by Emily Jeppson on 2/23/13.
//  Copyright (c) 2013 Emily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeItem.h"

@protocol PracticeOptionsDelegate
- (void)addColumn;
- (void)generateRandomData;
@end


@interface PracticeOptionsController : UIViewController
- (IBAction)addColumn:(id)sender;
- (IBAction)generateRandomData:(id)sender;

@property (nonatomic, strong) id<PracticeOptionsDelegate> delegate;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
