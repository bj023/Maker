//
//  ShopNewProductMoreCell.m
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopNewProductMoreCell.h"

@interface ShopNewProductCell ()

- (ShopNewProductItem *)itemFromNib;
- (void)loadItem:(ShopNewProductItem *)item toView:(UIView *)view;

@end

@implementation ShopNewProductMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (self.item0 == nil) {
        self.item0 = [self itemFromNib];
        [self loadItem:self.item0 toView:self.leftView];
    }
    
    if (self.item1 == nil) {
        self.item1 = [self itemFromNib];
        [self loadItem:self.item1 toView:self.rightView];
    }
}

- (ShopNewProductItem *)itemFromNib {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"ShopNewProductItem" owner:nil options:nil];
    return [viewArray objectAtIndex:0];
}

- (void)loadItem:(ShopNewProductItem *)item toView:(UIView *)view {
    item.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    item.frame = view.bounds;
    [view addSubview:item];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
