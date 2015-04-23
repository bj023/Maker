//
//  HomeRaidersCell.m
//  Discount
//
//  Created by 那宝军 on 15/4/14.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "HomeRaidersCell.h"

@implementation HomeRaidersCell

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
