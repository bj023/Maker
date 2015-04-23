//
//  CommonDefine.h
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#ifndef __COMMON_DEFINE_H__
#define __COMMON_DEFINE_H__


#define ONCE_PULL_ITEM_COUNT 20

#define IS_IOS_8_OR_LATER ([[UIDevice currentDevice].systemVersion integerValue] >= 8)

// third party share keys
// umeng key
extern NSString *const kUmengAppkey;

// sina
extern NSString *const kSinaWeiboAppKey;
extern NSString *const kSinaWeiboAppSecret;
extern NSString *const kSinaWeiboRedirectUri;

// wechat
extern NSString *const kWeChatAppId;
extern NSString *const kWeChatAppSecret;

#define kWeiXinAccessToken   @"WeiXinAccessToken"
#define kWeiXinOpenId        @"WeiXinOpenId"
#define kWeiXinRefreshToken  @"WeiXinRefreshToken"

// qq
extern NSString *const kQQAppId;
extern NSString *const kQQAppSecret;

// 高德地图
extern NSString *const kAMapKey;


#define TOAST_SHOW_TIME 2.0f

#endif // __COMMON_DEFINE_H__
