//
//  GoodsTableViewCell.h
//  Discount
//
//  Created by jackyzeng on 3/6/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  IBDiscountView;

@interface GoodsTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet IBDiscountView *discountView;

@property(nonatomic, strong, readonly)  UIImageView *productImageView;
@property(nonatomic, strong, readonly)  UILabel *nameLabel;
@property(nonatomic, strong, readonly)  UILabel *contentLabel;
@property(nonatomic, strong, readonly)  UIImageView *discountImageView;
@property(nonatomic, strong, readonly)  UILabel *discountLabel;
@property(nonatomic) NSInteger discount;

@end
