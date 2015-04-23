//
//  IBShopLocationView.m
//  Discount
//
//  Created by jackyzeng on 3/18/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBShopLocationView.h"

@implementation IBShopLocationView

- (UIView *)loadXib {
    UIView *view = [super loadXib];
    self.shopName.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.shopName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    return view;
}

@end
