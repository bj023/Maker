//
//  ShopNewProductInfo.h
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PriceLabel.h"

@class ItemBaseInfo;

@protocol ShopNewProductInfo <NSObject>

@required
@property(nonatomic, strong) IBOutlet UIImageView *productImageView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *contentLabel;
@property(nonatomic, strong) IBOutlet PriceLabel *priceLabel;
@property(nonatomic, strong) IBOutlet UIButton *likeButton;
@property(nonatomic, getter=isLiked) BOOL liked;
@property(nonatomic, strong) ItemBaseInfo *item;
@property(nonatomic, weak) UIViewController *vc;

@end
