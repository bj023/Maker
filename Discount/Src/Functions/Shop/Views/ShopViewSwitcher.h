//
//  ShopViewSwitcher.h
//  Discount
//
//  Created by jackyzeng on 3/4/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ShopRebateType = 3,// 退税 ->导购
    ShopBrandType = 6,// 品牌 -> 导购
}ShopPushType;

@interface ShopViewSwitcher : UIControl

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, readonly) NSInteger selectedIndex;


@property(nonatomic, strong)NSString *floor;
@property(nonatomic, strong)NSNumber *brandID;
@property(nonatomic, strong)NSNumber *serviceID;
@property(nonatomic, assign)ShopPushType shopType;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)selectIndex:(NSInteger)index;
- (void)sendValueChangedEvent;

@end
