//
//  PracticeItem.h
//  PlayField
//
//  Created by Emily Jeppson on 3/9/13.
//  Copyright (c) 2013 Jai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class PracticeColumn;

@interface PracticeItem : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * numberOfMinutes;
@property (nonatomic, retain) NSNumber * columnNumber;
@property (nonatomic, retain) NSString * itemType;
@property (nonatomic, retain) PracticeColumn *practiceColumn;


@property (nonatomic, strong) UIColor * backgroundColor;

- (void)createHeaderWithName:(NSString*)name;
- (void)createTimeItemWithLabel:(NSString*)label;
- (void)createTimeHeader;
@end
