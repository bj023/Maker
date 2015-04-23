//
//  HomeRaidersTableViewCell.m
//  Discount
//
//  Created by fengfeng on 15/3/18.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "HomeRaidersTableViewCell.h"

@implementation HomeRaidersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)contentLabel {
    return self.raidersView.contentLabel;
}

- (UIImageView *)raidersImageView {
    return self.raidersView.raidersImageView;
}

- (UIButton *)likeButton {
    return self.raidersView.likeButton;
}

- (UILabel *)address {
    return self.locationView.addressName;
}

- (UIShopNameButton *)shopName {
    return self.locationView.shopName;
}

@end
