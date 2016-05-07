//
//  Cart.h
//  GoodSnap
//
//  Created by Ruying Chen on 2/15/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cart : NSManagedObject

@property (nonatomic, retain) NSNumber * isChecked;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * barcode;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * type;

@end
