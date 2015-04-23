//
//  LocateBase.h
//  Discount
//
//  Created by jackyzeng on 3/28/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocateBase : NSManagedObject

@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSData * services;
@property (nonatomic, retain) NSData * floors;
@property (nonatomic, retain) NSString * floor;
@property (nonatomic, retain) NSString * imgUrl;
@property (nonatomic, retain) NSData * coords;
@property (nonatomic, retain) NSNumber * shopID;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;

@end
