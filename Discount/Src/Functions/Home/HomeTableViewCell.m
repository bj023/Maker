//
//  HomeTableViewCell.m
//  Discount
//
//  Created by fengfeng on 15/3/4.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "HomeTableViewCell.h"

#import "IBDiscountView.h"
#import "IBShopLocationView.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)productImage {
    return self.discountView.productImageView;
}

- (UILabel *)productName {
    return self.discountView.nameLabel;
}

- (UILabel *)productDetail {
    return self.discountView.contentLabel;
}

- (UILabel *)addressName {
    return self.locationView.addressName;
}

- (UIShopNameButton *)shopName {
    return self.locationView.shopName;
}

- (UIImageView *)productDiscont {
    return self.discountView.discountImageView;
}

@end
