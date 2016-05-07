//
//  ShoppingList.h
//  GoodSnap
//
//  Created by Ruying Chen on 2/5/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goods;

@interface ShoppingList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * lastTouchDate;
//@property (nonatomic, retain) Goods *cart;

@end
