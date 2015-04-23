//
//  IBDiscountView.h
//  Discount
//
//  Created by jackyzeng on 3/18/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDesignableView.h"

@interface IBDiscountView : IBDesignableView

@property(nonatomic, strong) IBOutlet UIImageView *productImageView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *contentLabel;
@property(nonatomic, strong) IBOutlet UIImageView *discountImageView;
@property(nonatomic, strong) IBOutlet UILabel *discountLabel;
@property(nonatomic) NSInteger discount;

@end
