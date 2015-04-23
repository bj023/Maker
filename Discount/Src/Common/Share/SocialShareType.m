//
//  SocialShareType.m
//  Discount
//
//  Created by jackyzeng on 3/29/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "SocialShareType.h"
#import "UMSocial.h"

NSString *platformNameForSocialShareType(SocialShareType type) {
    NSString * platformName = nil;
    
    if (type == SocialShareTypeWeChatTimeLine) {
        platformName = UMShareToWechatTimeline;
    }
    if (type == SocialShareTypeWeChatSession) {
        platformName = UMShareToWechatSession;
    }
    else if (type == SocialShareTypeSinaWeibo) {
        platformName = UMShareToSina;
    }
    else if (type == SocialShareTypeQQ) {
        // !!! info.plist 一定要set CFBundleDisplayName，否则无法正常跳转到QQ授权 !!!
        // QQ登录授权，若使用UMShareToQQ，在未安装QQ时无法调起网页方式授权，而是提示下载QQ
        // 参见：http://bbs.umeng.com/forum.php?extra=page=5&filter=typeid&mod=viewthread&orderby=lastpost&tid=4557&typeid=13
        platformName = UMShareToQzone;
    }
    
    return platformName;
}
