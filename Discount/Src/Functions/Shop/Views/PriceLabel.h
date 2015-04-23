//
//  PriceLabel.h
//  Discount
//
//  Created by MacQB on 3/15/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceLabel : UILabel

@property(nonatomic, strong) NSString *price;

- (void)setPrice:(NSString *)price withCount:(NSInteger)count;

@end
