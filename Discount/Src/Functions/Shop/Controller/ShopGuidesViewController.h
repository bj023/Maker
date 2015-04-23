//
//  ShopGuidesViewController.h
//  Discount
//
//  Created by jackyzeng on 3/12/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopBaseViewController.h"

@class TapDetectingImageView;


@interface ShopGuidesViewController : ShopBaseViewController

// 品牌
- (void)clickFindLocationWithBrandID:(NSNumber*)brandID Floor:(NSString *)floor;
// 退税
- (void)clickFindLocationWithServiceID:(NSNumber*)serviceID Floor:(NSString *)floor;
// 导购
- (void)clickFindLocation;

@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) TapDetectingImageView *imageView;

@end
