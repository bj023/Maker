//
//  ShopSearchBrandTypeCell.m
//  Discount
//
//  Created by jackyzeng on 3/17/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopSearchBrandTypeCell.h"

@implementation ShopSearchBrandTypeCell

- (void)awakeFromNib {
    self.currentType = ShopSearchValueTypeKind;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width / 2;
    if (self.markLine == nil) {
        self.markLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, width, 2)];
        self.markLine.backgroundColor = MAIN_THEME_COLOR;
        [self addSubview:self.markLine];
    }
    CGRect markLineFrame = self.markLine.frame;
    markLineFrame.size.width = width;
    if (self.currentType == ShopSearchValueTypeKind) {
        markLineFrame.origin.x = 0;
    }
    else {
        markLineFrame.origin.x = width;
    }
    self.markLine.frame = markLineFrame;
}

- (void)setCurrentType:(ShopSearchValueType)currentType {
    _currentType = currentType;
    
    if (currentType == ShopSearchValueTypeKind) {
        [self.kindButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
        [self.alphabetButton setTitleColor:SS_HexRGBColor(0x333333) forState:UIControlStateNormal];
    }
    else {
        [self.kindButton setTitleColor:SS_HexRGBColor(0x333333) forState:UIControlStateNormal];
        [self.alphabetButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
    }
}

- (IBAction)buttonPressed:(id)sender {
    ShopSearchValueType type = self.currentType;
    if (sender == self.kindButton) {
        self.currentType = ShopSearchValueTypeKind;
    }
    else {
        self.currentType = ShopSearchValueTypeAlphabet;
    }
    
    CGFloat width = self.frame.size.width / 2;
    CGRect markLineFrame = self.markLine.frame;
    CGRect leftFrame = markLineFrame;
    CGRect rightFrame = markLineFrame;
    leftFrame.origin.x = 0;
    leftFrame.size.width = width;
    rightFrame.origin.x = width;
    rightFrame.size.width = width;
    if (type != self.currentType) {
        if (self.currentType == ShopSearchValueTypeKind) {
            markLineFrame = leftFrame;
        }
        else {
            markLineFrame = rightFrame;
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            self.markLine.frame = markLineFrame;
        } completion:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(brandTypeCell:selectType:)]) {
                [self.delegate brandTypeCell:self selectType:self.currentType];
            }
        }];
    }
}

@end
