//
//  Coupon.h
//  Discount
//
//  Created by bilsonzhou on 15/3/26.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemBaseInfo.h"


@interface Coupon : ItemBaseInfo

@property (nonatomic, retain) NSNumber * couponID;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * expired;
@property (nonatomic, retain) NSNumber * used;

@end
