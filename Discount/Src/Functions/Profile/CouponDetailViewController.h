//
//  CouponDetailViewController.h
//  Discount
//
//  Created by bilsonzhou on 15/3/27.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponDetailViewController : UIViewController

@property (nonatomic, strong) NSNumber* couponID;

- (instancetype)initWithCouponID:(NSNumber *)couponID;

@end
