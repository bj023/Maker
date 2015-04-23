//
//  UIViewController+loginHelper.m
//  Discount
//
//  Created by fengfeng on 15/4/8.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "UIViewController+loginHelper.h"
#import "LoginViewController.h"

@implementation UIViewController (loginHelper)

- (void)showLoginViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kLoginRegisterStoryboard bundle:nil];
    LoginViewController *login = [storyboard instantiateInitialViewController];
    [self presentViewController:login animated:YES completion:^{
        // completion
    }];
}

@end
