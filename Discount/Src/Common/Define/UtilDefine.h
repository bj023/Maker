//
//  UtilDefine.h
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#ifndef Discount_UtilDefine_h
#define Discount_UtilDefine_h

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define Arraysize(x) (sizeof(x)/sizeof(x[0]))
#define APP_ID @"978932835"

// UI Define

// colors
// 主题颜色：红
#define MAIN_THEME_COLOR SS_RGBColor(255, 0, 60)
// 分割线颜色
#define SEPARATOR_COLOR SS_HexRGBAColor(0xe2e2e2)
// 主题背景色
#define BACKGROUND_COLOR SS_HexRGBAColor(0xefefef)

// height for controls
#define NAVIGATIONBAR_HEIGHT 44.0f
#define STATUSBAR_HEIGHT 20.0f
#define TOOLBAR_HEIGHT 44.0f
#define MAXIMUM_RIGHT_DRAWER_WIDTH ([UIScreen mainScreen].bounds.size.width - 50.0f)

#define SEXSTRBY(a) (a == 1 ? @"男":@"女")
#define ADDRSTRBY(province, city) ([NSString stringWithFormat:@"%@ - %@", province, city])

#define MAIN_URL @"http://api.traveler99.com/"
#define kUserAgreementURLString ([NSString stringWithFormat:@"%@site/agreement",MAIN_URL]) 

// float 比较
// see http://stackoverflow.com/questions/1614533/strange-problem-comparing-floats-in-objective-c/1614761#1614761
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)
#define flessthan(a,b) (fabs(a) < fabs(b)+FLT_EPSILON)

#define NoNullString(string) ((string != nil) ? string : @"")


// 判断字符串是否为空
#define IsEmpty(str) (![str respondsToSelector:@selector(isEqualToString:)] || [str isEqualToString:@""])

#endif
