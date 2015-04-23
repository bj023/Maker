//
//  ShopNewProductMoreCell.h
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopNewProductCell.h"
#import "ShopNewProductItem.h"

@interface ShopNewProductMoreCell : ShopNewProductCell

@property(nonatomic, strong) ShopNewProductItem *item0;
@property(nonatomic, strong) ShopNewProductItem *item1;

@property(nonatomic, strong) IBOutlet UIView *leftView;
@property(nonatomic, strong) IBOutlet UIView *rightView;

@end
