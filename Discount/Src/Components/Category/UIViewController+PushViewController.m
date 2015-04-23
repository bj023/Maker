//
//  UIViewController+PushViewController.m
//  StarShow
//
//  Created by jackyzeng on 1/18/15.
//  Copyright (c) 2015 starshow. All rights reserved.
//

#import "UIViewController+PushViewController.h"
#import "LogoNavigationController.h"

@implementation UIViewController (PushViewController)

- (void)pushViewControllerInNavgation:(UIViewController *)viewController animated:(BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
    BOOL shouldShowBottomBarWhenPoped = YES;
    if (self.navigationController.viewControllers.count > 1) {
        shouldShowBottomBarWhenPoped = NO;
    }
    if ([self.navigationController isKindOfClass:[LogoNavigationController class]]) {
        LogoNavigationController *logoNavi = (LogoNavigationController *)self.navigationController;
        logoNavi.logoView.hidden = YES;
        logoNavi.titleView.hidden = NO;
    }
    [self.navigationController pushViewController:viewController animated:animated];
    if (shouldShowBottomBarWhenPoped) {
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end
