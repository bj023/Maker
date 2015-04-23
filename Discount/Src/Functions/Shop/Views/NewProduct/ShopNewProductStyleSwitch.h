//
//  ShopNewProductStyleSwitch.h
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopNewProductViewStyle.h"

@interface ShopNewProductStyleSwitch : UIControl

@property(nonatomic, strong) IBOutlet UIButton *singleButton;
@property(nonatomic, strong) IBOutlet UIButton *moreButton;

@property(nonatomic) ShopNewProductViewStyle currentStyle;

@end
