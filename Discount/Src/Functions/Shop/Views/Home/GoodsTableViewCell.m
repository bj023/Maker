//
//  GoodsTableViewCell.m
//  Discount
//
//  Created by jackyzeng on 3/6/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "GoodsTableViewCell.h"

#import "IBDiscountView.h"

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//@property(nonatomic, strong) IBOutlet UIImageView *productImageView;
//@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
//@property(nonatomic, strong) IBOutlet UILabel *contentLabel;
//@property(nonatomic, strong) IBOutlet UIImageView *discountImageView;
//@property(nonatomic, strong) IBOutlet UILabel *discountLabel;

- (UIImageView *)productImageView {
    return self.discountView.productImageView;
}

- (UILabel *)nameLabel {
    return self.discountView.nameLabel;
}

- (UILabel *)contentLabel {
    return self.discountView.contentLabel;
}

- (UILabel *)discountLabel {
    return self.discountView.discountLabel;
}

- (NSInteger)discount {
    return self.discountView.discount;
}

- (void)setDiscount:(NSInteger)discount {
    self.discountView.discount = discount;
}

@end
