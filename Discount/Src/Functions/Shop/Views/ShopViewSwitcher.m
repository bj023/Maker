//
//  ShopViewSwitcher.m
//  Discount
//
//  Created by jackyzeng on 3/4/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopViewSwitcher.h"

@interface ShopViewSwitcher ()

@property(nonatomic, strong) NSMutableArray *switchButtons;
@property(nonatomic, strong) UIImageView *shadowImageView;
- (void)layoutShadowImageView;

@end

@implementation ShopViewSwitcher

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        _switchButtons = [NSMutableArray array];
        self.titles = titles;
        [self layoutShadowImageView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _switchButtons = [NSMutableArray array];
        _titles = @[];
        [self layoutShadowImageView];
    }
    
    return self;
}

- (void)layoutShadowImageView {
    if (_shadowImageView == nil) {
        _shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 2.5f)];
        _shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_shadowImageView setImage:[UIImage imageNamed:@"shop_switch_shadow"]];
        [self addSubview:_shadowImageView];
    }
}

- (void)setTitles:(NSArray *)titles {
    for (UIButton *button in self.switchButtons) {
        [button removeFromSuperview];
    }
    [self.switchButtons removeAllObjects];
    
    _titles = titles;
    NSInteger count = [_titles count];
    CGFloat x = 0, y = 0, w = floorf(self.bounds.size.width / count), h = self.bounds.size.height;
    for (NSInteger index = 0; index < count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_titles[index] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(x, y, w, h)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [button addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_switchButtons addObject:button];
        
        x += w;
    }
    
    [self selectIndex:0];
}

- (void)layoutSubviews {
    NSInteger count = [self.switchButtons count];
    CGFloat x = 0, y = 0, w = floorf(self.bounds.size.width / count), h = self.bounds.size.height;
    for (NSInteger index = 0; index < count; index++) {
        UIButton *button = (UIButton *)self.switchButtons[index];
        [button setFrame:CGRectMake(x, y, w, h)];
        
        x += w;
    }
}

- (void)selectIndex:(NSInteger)index {
    if (index != 0 && index == self.selectedIndex) {
        return;
    }
    
    if (index < 0 || index >= [self.switchButtons count]) {
        index = 0;
    }
    
    UIButton *oldSelectedButton = (UIButton *)self.switchButtons[self.selectedIndex];
    [oldSelectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *currentSelectedButton = (UIButton *)self.switchButtons[index];
    [currentSelectedButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
    
    _selectedIndex = index;
}

- (void)sendValueChangedEvent {
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)onButtonPressed:(UIButton *)sender {
    SSLog(@"pressed view switch button...");
    NSInteger index = 0;
    for (UIButton *button in self.switchButtons) {
        if (button == sender) {
            BOOL shouldSendEvent = (index != self.selectedIndex);
            [self selectIndex:index];
            if (shouldSendEvent) {
                [self sendValueChangedEvent];
            }
            break;
        }
        index++;
    }
}

@end
