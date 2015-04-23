//
//  ShopGuideButton.h
//  Discount
//
//  Created by jackyzeng on 3/12/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopGuideButton : UIButton

@property(nonatomic, getter=isOn) BOOL on;
@property(nonatomic, strong) UIImage *offImage;
@property(nonatomic, strong) UIImage *onImage;

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage;

- (void)setOnImage:(UIImage *)onImage offImage:(UIImage *)offImage;

@end
