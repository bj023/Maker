//
//  ShopGuideButton.m
//  Discount
//
//  Created by jackyzeng on 3/12/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopGuideButton.h"

@interface ShopGuideButton ()

- (void)initUI;

@end

@implementation ShopGuideButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    
    return self;
}
         
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage {
    CGSize size = onImage.size;
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
        [self initUI];
        [self setOnImage:onImage offImage:offImage];
    }
    
    return self;
}

- (void)initUI {
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    
    self.backgroundColor = [UIColor clearColor];
    //self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
    self.on = NO;
}

- (void)setOnImage:(UIImage *)onImage offImage:(UIImage *)offImage {
    self.onImage = onImage;
    self.offImage = offImage;
    
    self.on = self.isOn;
}

- (void)setOn:(BOOL)on {
    _on = on;
    
    if (self.offImage && self.onImage) {
        if (_on) {
            [self setImage:self.onImage forState:UIControlStateNormal];
        }
        else {
            [self setImage:self.offImage forState:UIControlStateNormal];
            [self setImage:self.onImage forState:UIControlStateHighlighted];
        }
    }
    else {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        if (_on) {
            self.backgroundColor = [UIColor whiteColor];
            [self setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
        }
        else {
            [self setTitleColor:SS_RGBColor(102, 102, 102) forState:UIControlStateNormal];
            [self setTitleColor:MAIN_THEME_COLOR forState:UIControlStateHighlighted];
        }
    }
}

@end
