//
//  HomeNewProductTableViewCell.m
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "HomeNewProductTableViewCell.h"

@interface HomeNewProductTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *LineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posImageView;

@end

@implementation HomeNewProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hidenButtonInfo
{
    self.LineImageView.hidden = YES;
    self.posImageView.hidden = YES;
    self.address.hidden = YES;
    self.shopName.hidden = YES;
}

@end
