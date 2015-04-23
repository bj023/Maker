//
//  UIViewController+GoShop.h
//  Discount
//
//  Created by jackyzeng on 4/10/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShopType) {
    ShopTypeHome = 0,
    ShopTypeNewProduct,
    ShopTypeDiscount,
    ShopTypeBrand,
    ShopTypeRaiders,
    ShopTypeGuide,
    ShopTypeRebate
};

@interface UIViewController (GoShop)

- (void)goShopViewControllerWithId:(NSNumber *)shopId;
- (void)goShopViewControllerWithId:(NSNumber *)shopId type:(ShopType)type;
- (void)goShopViewControllerWithId:(NSNumber *)shopId type:(ShopType)type animated:(BOOL)animated;

@end
