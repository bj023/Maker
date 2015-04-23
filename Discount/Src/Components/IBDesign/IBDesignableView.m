//
//  IBDesignableView.m
//  Discount
//
//  Created by jackyzeng on 3/18/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDesignableView.h"

@implementation IBDesignableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadXib];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadXib];
        
    }
    
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    
    return self;
}


- (UIView *)loadXib
{
    UIView *view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:[self nibName] owner:self options:nil] objectAtIndex:0];
    
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.frame = self.bounds;
    [self addSubview:view];
    
    return view;
}

- (NSString *)nibName {
    return NSStringFromClass([self class]);
}


@end
