//
//  ShopRaidersCell.m
//  Discount
//
//  Created by jackyzeng on 3/8/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopRaidersCell.h"

@implementation ShopRaidersCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

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

- (BOOL)isLiked {
    return self.raidersView.isLiked;
}

- (void)setLiked:(BOOL)liked {
    [self.raidersView setLiked:liked];
}

@end
