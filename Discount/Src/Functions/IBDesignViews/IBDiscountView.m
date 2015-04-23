//
//  IBDiscountView.m
//  Discount
//
//  Created by jackyzeng on 3/18/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDiscountView.h"

@implementation IBDiscountView

- (void)setDiscount:(NSInteger)discount {
    if (discount < 0) {
        discount = 0;
    }
    else if (discount > 100) {
        discount = 100;
    }
    
    if (discount == 0) {
        self.discountImageView.hidden = YES;
        self.discountLabel.hidden = YES;
    }
    else {
        self.discountImageView.hidden = NO;
        self.discountLabel.hidden = NO;
        
        self.discountLabel.text = [NSString stringWithFormat:@"%d%%", (int)discount];
    }
}

@end
