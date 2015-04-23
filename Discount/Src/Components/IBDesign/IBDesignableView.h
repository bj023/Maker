//
//  IBDesignableView.h
//  Discount
//
//  Created by jackyzeng on 3/18/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface IBDesignableView : UIView

- (NSString *)nibName;
- (UIView *)loadXib;

@end
