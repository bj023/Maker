//
//  IBDestinationHeaderView.m
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDestinationHeaderView.h"

@interface IBDestinationHeaderView ()

@property(nonatomic, strong) UIView *markLine;

@end

@implementation IBDestinationHeaderView

- (UIView *)loadXib {
    UIView *v = [super loadXib];
    _dest = E_DESITION_ASIA;
    _shouldHideMarkLine = YES;
    return v;
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width / 3;
    if (self.markLine == nil) {
        self.markLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 3, width - 20, 3)];
        self.markLine.backgroundColor = MAIN_THEME_COLOR;
        [self addSubview:self.markLine];
        [self.markLine setHidden:self.shouldHideMarkLine];
    }
    
    CGRect markLineFrame = self.markLine.frame;
    markLineFrame.size.width = width - 20;
    markLineFrame.origin.x = 10 + width * (self.dest - 1);
    
    self.markLine.frame = markLineFrame;
}

- (void)setDest:(E_DESITION)dest {
    [self setDest:dest animated:NO];
}

- (void)setDest:(E_DESITION)dest animated:(BOOL)animated {
    [self setDest:dest animated:animated notifyDelegate:NO];
}

- (void)setDest:(E_DESITION)dest animated:(BOOL)animated notifyDelegate:(BOOL)notify {
    E_DESITION lastDest = self.dest;
    _dest = dest;
    if (_dest < E_DESITION_BEGIN || _dest >= E_DESITION_END) {
        _dest = E_DESITION_ASIA;
    }
    
    CGFloat width = self.frame.size.width / 3;
    CGRect markLineFrame = self.markLine.frame;
    markLineFrame.size.width = width - 20;
    markLineFrame.origin.x = 10 + width * (_dest - 1);
    if (lastDest != _dest)
    {
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                self.markLine.frame = markLineFrame;
            } completion:^(BOOL finished) {
                if (notify) {
                    [self notifyDelegate];
                }
            }];
        }
        else {
            self.markLine.frame = markLineFrame;
        }
    }
    
    if ((lastDest == _dest || !animated) && notify) {
        [self notifyDelegate];
    }

}

- (IBAction)onButtonPressed:(id)sender {
    E_DESITION dest = (E_DESITION)[sender tag];
    [self setDest:dest animated:YES notifyDelegate:YES];
}

- (void)notifyDelegate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:didSelectDestination:)]) {
        [self.delegate view:self didSelectDestination:self.dest];
    }
}

@end
