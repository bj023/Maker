//
//  UIColor+SSExt.h
//  StarShow
//
//  Created by jackyzeng on 14/9/13.
//  Copyright (c) 2014年 StarShow. All rights reserved.
//

#ifndef __UICLOR_RREXT_H_
#define __UICLOR_RREXT_H_

#import <UIKit/UIKit.h>

#define SS_RGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SS_RGBColor(r, g, b) SS_RGBAColor(r, g, b, 1)
#define SS_HexRGBAColor(hex, a) SS_RGBAColor(((Byte)(hex >> 16)), ((Byte)(hex >> 8)), ((Byte)(hex)), a)
#define SS_HexRGBColor(hex) SS_HexRGBAColor(hex, 1)

@interface UIColor (SSExt)

+ (UIColor *)colorWithRGB:(int)color alpha:(float)alpha;

@end

#endif // __UICLOR_RREXT_H_
