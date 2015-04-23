//
//  IBSocialLoginView.m
//  Discount
//
//  Created by jackyzeng on 3/23/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBSocialLoginView.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>

@interface IBSocialLoginView ()

@property(nonatomic, strong) IBOutlet UIButton *wxButton;

@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@end

@implementation IBSocialLoginView

- (UIView *)loadXib {
    UIView *view = [super loadXib];
    //self.wxButton.hidden = ![WXApi isWXAppInstalled];
    //self.qqButton.hidden = ![QQApi isQQInstalled];
    
    if ([WXApi isWXAppInstalled]) {
        self.wxButton.userInteractionEnabled = YES;
        self.wxButton.enabled = YES;
    }else
    {
        self.wxButton.userInteractionEnabled = NO;
        self.wxButton.enabled = NO;
    }
    
    if ([QQApi isQQInstalled]) {

        self.qqButton.userInteractionEnabled = YES;
        self.qqButton.enabled = YES;
    }else
    {
        self.qqButton.userInteractionEnabled = NO;
        self.qqButton.enabled = NO;
    }

    return view;
}

- (IBAction)loginButtonPressed:(id)sender {
    SocialShareType type = (SocialShareType)[sender tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(socialLoginView:loginWithType:)]) {
        [self.delegate socialLoginView:self loginWithType:type];
    }
}

@end
