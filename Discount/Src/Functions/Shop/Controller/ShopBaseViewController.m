//
//  ShopBaseViewController.m
//  Discount
//
//  Created by jackyzeng on 3/28/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopBaseViewController.h"

@interface ShopBaseViewController ()

@end

@implementation ShopBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_shopID == nil) {
        _shopID = @(0);
    }
}

@end
