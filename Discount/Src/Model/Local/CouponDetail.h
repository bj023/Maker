//
//  CouponDetail.h
//  Discount
//
//  Created by bilsonzhou on 15/3/26.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Coupon.h"


@interface CouponDetail : Coupon

@property (nonatomic, retain) NSString * shopLogo;
@property (nonatomic, retain) NSString * nameCn;
@property (nonatomic, retain) NSString * nameLocal;
@property (nonatomic, retain) NSString * detailCn;
@property (nonatomic, retain) NSString * detailLocal;
@property (nonatomic, retain) NSString * attentionCn;
@property (nonatomic, retain) NSString * attentionLocal;

@end
