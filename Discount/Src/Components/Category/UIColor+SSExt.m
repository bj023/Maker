//
//  UIColor+SSExt.m
//  StarShow
//
//  Created by jackyzeng on 14/9/13.
//  Copyright (c) 2014年 starshow. All rights reserved.
//

#import "UIColor+SSExt.h"

@implementation UIColor (SSExt)

+ (UIColor *)colorWithRGB:(int)color alpha:(float)alpha {
    return [UIColor colorWithRed:((Byte)(color >> 16))/255.0
                           green:((Byte)(color >> 8))/255.0
                            blue:((Byte)color)/255.0 alpha:alpha];
}

@end

