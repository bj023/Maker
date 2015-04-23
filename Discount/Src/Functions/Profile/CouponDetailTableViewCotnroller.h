//
//  CouponDetailTableViewCotnroller.h
//  Discount
//
//  Created by jackyzeng on 4/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "BaseTableViewController.h"

@class CouponDetail;

@interface CouponDetailTableViewCotnroller : BaseTableViewController

@property (nonatomic,strong) NSNumber* couponID;

- (void)setCouponDetail:(CouponDetail *)couponDetail;

@end
