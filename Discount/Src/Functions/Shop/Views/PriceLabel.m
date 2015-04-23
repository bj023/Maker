//
//  PriceLabel.m
//  Discount
//
//  Created by MacQB on 3/15/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "PriceLabel.h"

@interface PriceLabel ()

- (NSRange)boldRangeOfPrice:(NSString *)price inRange:(NSRange)range;

@end

@implementation PriceLabel

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self setPrice:text];
}

- (void)setPrice:(NSString *)price {
    NSArray *components = [price componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger count = [components count] > 0 ? [components count] : 1;
    [self setPrice:price withCount:count];
}

- (NSRange)boldRangeOfPrice:(NSString *)price inRange:(NSRange)range {
    NSRange beginRange = [price rangeOfString:@"：" options:0 range:range];
    if (beginRange.location == NSNotFound) {
        beginRange = [price rangeOfString:@":" options:0 range:range];
    }
    if (beginRange.location == NSNotFound) {
        return NSMakeRange(NSNotFound, 0);
    }
    NSRange endRange = [price rangeOfString:@"." options:0 range:range];
    if (endRange.location == NSNotFound) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    NSRange boldRange = NSMakeRange(beginRange.location + 1, endRange.location - beginRange.location - 1);
    return boldRange;
}

- (void)setPrice:(NSString *)price withCount:(NSInteger)count {
    
    // 如果没有价格 不显示
    NSString *trimWhitespace = [price stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimWhitespace.length == 0) {
        return;
    }
    
    _price = price;
    
    NSMutableAttributedString *attributedPrice = [[NSMutableAttributedString alloc] initWithString:price];
    [attributedPrice addAttributes:@{NSForegroundColorAttributeName:SS_HexRGBColor(0x999999)} range:NSMakeRange(0, [price length])];
    
    if (count == 0) {
        self.attributedText = attributedPrice;
        return;
    }
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    NSRange range = NSMakeRange(0, 0);
    for (NSInteger index = 0; index < count; index++) {
        NSInteger offset = index == 0 ? 0 : 2; // see |boldRangeOfPrice:inRange:|
        range = [self boldRangeOfPrice:price inRange:NSMakeRange(range.location + range.length + offset,
                                                                 price.length - range.location - range.length - offset)];
        if (range.location == NSNotFound) {
            break;
        }
        // 这里需要改动
        //[attributedPrice addAttributes:attributes range:range];
    }
    self.attributedText = attributedPrice;
}

@end
