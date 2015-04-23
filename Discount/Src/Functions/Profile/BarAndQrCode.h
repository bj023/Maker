//
//  BarAndQrCode.h
//  Discount
//
//  Created by bilsonzhou on 15/3/27.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarAndQrCode : NSObject

+ (UIImage *)doQREncodeWithString:(NSString *)str size:(NSInteger)size;

+ (UIImage *)doBarEncodeWithString:(NSString *)str size:(NSInteger)size;
@end
