//
//  ShopNewProductStyleSwitch.m
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopNewProductStyleSwitch.h"

@implementation ShopNewProductStyleSwitch

- (IBAction)onButtonPressed:(UIButton *)sender {
    SSLog(@"pressed product style switch button...");
    
    if (self.currentStyle == ShopNewProductViewStyleSingle && sender == self.moreButton) {
        self.currentStyle = ShopNewProductViewStyleMore;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    else if (self.currentStyle == ShopNewProductViewStyleMore && sender == self.singleButton) {
        self.currentStyle = ShopNewProductViewStyleSingle;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setCurrentStyle:(ShopNewProductViewStyle)currentStyle {
    _currentStyle = currentStyle;
    
    if (_currentStyle == ShopNewProductViewStyleSingle) {
        [self.singleButton setImage:[UIImage imageNamed:@"product_single_on"] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"product_more_off"] forState:UIControlStateNormal];
    }
    else {
        [self.singleButton setImage:[UIImage imageNamed:@"product_single_off"] forState:UIControlStateNormal];
        [self.moreButton setImage:[UIImage imageNamed:@"product_more_on"] forState:UIControlStateNormal];
    }
}

@end
