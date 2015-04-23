//
//  SocialShareType.h
//  Discount
//
//  Created by jackyzeng on 3/29/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#ifndef __SOCIAL_SHARE_TYPE_H__
#define __SOCIAL_SHARE_TYPE_H__

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SocialShareType) {
    SocialShareTypeWeChatTimeLine = 0,
    SocialShareTypeWeChatSession,
    SocialShareTypeSinaWeibo,
    SocialShareTypeQQ,
};

NSString *platformNameForSocialShareType(SocialShareType type);

#endif
