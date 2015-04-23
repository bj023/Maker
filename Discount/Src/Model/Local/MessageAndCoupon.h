//
//  MessageAndCoupon.h
//  Discount
//
//  Created by fengfeng on 15/4/11.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageAndCoupon : NSManagedObject

@property (nonatomic, retain) NSNumber * messageCount;
@property (nonatomic, retain) NSNumber * couponCount;

@end
