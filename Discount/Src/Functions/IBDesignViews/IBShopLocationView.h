//
//  IBShopLocationView.h
//  Discount
//
//  Created by jackyzeng on 3/18/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDesignableView.h"
#import "UIShopNameButton.h"

@interface IBShopLocationView : IBDesignableView

@property (weak, nonatomic) IBOutlet UILabel *addressName;
@property (weak, nonatomic) IBOutlet UIShopNameButton *shopName;

@end
