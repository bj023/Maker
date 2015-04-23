//
//  HomeNewProductTableViewCell.h
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceLabel.h"
#import "UIShopNameButton.h"
#import "LikeButton.h"

@interface HomeNewProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productBrand;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet PriceLabel *price1;
@property (weak, nonatomic) IBOutlet PriceLabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIShopNameButton *shopName;
@property (weak, nonatomic) IBOutlet LikeButton *likeButton;

- (void)hidenButtonInfo;

@end
