//
//  MenuHeaderView.m
//  Discount
//
//  Created by jackyzeng on 3/14/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "MenuHeaderView.h"
#import "UIImage+Mask.h"

@interface HeaderImageButton : UIButton

- (void)setupUI;

@end

@implementation HeaderImageButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    [self setImage:[UIImage imageNamed:@"login_header_default"] forState:UIControlStateNormal];
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.clipsToBounds = YES;
}

@end

@implementation MenuHeaderView

@end
