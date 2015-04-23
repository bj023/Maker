//
//  ShopInfoTableHeaderView.h
//  Discount
//
//  Created by jackyzeng on 3/8/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDesignableView.h"

@interface ShopInfoTableHeaderView : IBDesignableView

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *locationLabel;

@end
