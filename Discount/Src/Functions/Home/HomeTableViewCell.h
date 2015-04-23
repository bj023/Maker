//
//  HomeTableViewCell.h
//  Discount
//
//  Created by fengfeng on 15/3/4.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIShopNameButton.h"

#define HomeTableViewIdentifier @"HomeTableViewCell"

@class IBDiscountView;
@class IBShopLocationView;

@interface HomeTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet IBDiscountView *discountView;
@property(nonatomic, strong) IBOutlet IBShopLocationView *locationView;

@property (weak, nonatomic, readonly) UIImageView *productImage;
@property (weak, nonatomic, readonly) UILabel *productName;
@property (weak, nonatomic, readonly) UILabel *productDetail;
@property (weak, nonatomic, readonly) UILabel *addressName;
@property (weak, nonatomic, readonly) UIShopNameButton *shopName;
@property (weak, nonatomic, readonly) UIImageView *productDiscont;

@end
