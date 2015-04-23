//
//  LogoNavigationController.m
//  Discount
//
//  Created by jackyzeng on 3/5/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "LogoNavigationController.h"

@interface LogoNavigationController ()

@end

@implementation LogoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView = [self.navigationBar valueForKey:@"_titleView"];
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_logo"]];
    self.logoView.center = self.titleView.center;
    self.logoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.titleView.hidden = YES;
    [self.navigationBar addSubview:self.logoView];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [super popViewControllerAnimated:animated];
    if (self.viewControllers.count == 1) {
        self.titleView.hidden = YES;
        self.logoView.hidden = NO;
    }
    
    return controller;
}

@end
