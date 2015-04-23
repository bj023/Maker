//
//  ShareSheet.m
//  Discount
//
//  Created by jackyzeng on 3/12/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShareSheet.h"
#import "IBShareView.h"
#import "ShareViewController.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"

static NSInteger const kMaxShareContentLength = 682;

@interface ShareSheet () <ShareViewDelegate, UMSocialUIDelegate>

@property(nonatomic, strong) UIViewController *controller;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *defaultContent;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *shareDescription;
@property(nonatomic, strong) UIImage *image;

@end

@implementation ShareSheet

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (BOOL)shareWithContent:(NSString *)content
          defaultContent:(NSString *)defaultContent
                   image:(UIImage *)image
                   title:(NSString *)title
                     url:(NSString *)url
             description:(NSString *)description {
    
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *vc = [[ShareViewController alloc] initWithShareViewDelegate:self];
    vc.view.backgroundColor = [UIColor clearColor];
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
    if(IS_IOS_8_OR_LATER)
    {
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
#endif
    
    [controller presentViewController:vc animated:YES completion:^{
        vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }];
    
    self.controller = controller;
    self.content = content;
    self.defaultContent = defaultContent;
    self.image = image;
    self.title = title;
    self.url = url;
    self.shareDescription = description;
    
    return YES;
}

#pragma mark - ShareViewDelegate

- (void)shareView:(IBShareView *)shareView clickButtonWithType:(SocialShareType)type {
    NSString *platform = platformNameForSocialShareType(type);
    if (platform == nil) {
        return;
    }
    
    UMSocialUrlResource *urlResource = [UMSocialUrlResource new];
    [urlResource setResourceType:UMSocialUrlResourceTypeDefault url:self.url];
    if (type == SocialShareTypeWeChatSession) {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
    }
    else if (type == SocialShareTypeWeChatTimeLine) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
    }
    else if (type == SocialShareTypeQQ) {
        [UMSocialData defaultData].extConfig.qqData.title = self.title;
        [UMSocialData defaultData].extConfig.qqData.url = self.url;
    }
    
    if ([platform isEqualToString:UMShareToWechatTimeline] ||
        [platform isEqualToString:UMShareToWechatSession]) {
        if (self.content.length > kMaxShareContentLength) {
            self.content = [self.content substringToIndex:kMaxShareContentLength];
        }
    }

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[platform]
                                                        content:self.content
                                                          image:self.image
                                                       location:nil
                                                    urlResource:urlResource
                                            presentedController:self.controller
                                                     completion:^(UMSocialResponseEntity *response){
                                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                                             SSLog(@"分享成功！");
                                                             UIViewController *presentedViewController = [self.controller presentedViewController];
                                                             if (presentedViewController) {
                                                                 [presentedViewController dismissViewControllerAnimated:YES completion:^{
                                                                     [self shareViewDidDismiss:nil];
                                                                 }];
                                                             }
                                                         }
                                                     }];
}

- (void)shareViewDidDismiss:(IBShareView *)shareView {
    self.controller = nil;
    self.content = nil;
    self.defaultContent = nil;
    self.image = nil;
    self.title = nil;
    self.url = nil;
    self.shareDescription = nil;
}

@end
    