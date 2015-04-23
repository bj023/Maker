//
//  NewProductInfoView.h
//  Discount
//
//  Created by fengfeng on 15/3/8.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceLabel.h"
#import "IBDesignableView.h"
#import "UIShopNameButton.h"
#import "LikeButton.h"

@interface NewProductInfoView : IBDesignableView

@property (weak, nonatomic) IBOutlet UILabel *brand;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIShopNameButton *shopName;
@property (weak, nonatomic) IBOutlet PriceLabel *price1;
@property (weak, nonatomic) IBOutlet PriceLabel *price2;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet LikeButton *likeButton;


//@property(nonatomic, retain) NSNumber *shopID;
//@property(nonatomic, retain) NSNumber *goodsID;
@property(nonatomic, retain) ItemBaseInfo * item;

@end
