//
//  BaseNavigationController.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+ (void)initialize {
    UIColor *mainThemeColor = MAIN_THEME_COLOR;
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBarTintColor:mainThemeColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 自定义UITextField和UITextView光标颜色
    [[UITextField appearance] setTintColor:mainThemeColor];
    [[UITextView appearance] setTintColor:mainThemeColor];
    
    // 自定义SearchBar按钮文字颜色
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:mainThemeColor}
                                                                                        forState:UIControlStateNormal];
    // 自定义switch颜色
    [[UISwitch appearance] setTintColor:mainThemeColor];
    [[UISwitch appearance] setOnTintColor:mainThemeColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
    
    // remove bottom line of navigationBar
    NSString *barBackgroundClassString = [NSString stringWithFormat:@"%@Bar%@", @"_UINavigation", @"Background"]; // _UINavigationBarBackground
    for (UIView *subview in self.navigationBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(barBackgroundClassString)]) {
            for (UIView *ss in [subview subviews]) {
                if ([ss isKindOfClass:[UIImageView class]] && ss.frame.size.height <=1) {
                    [ss removeFromSuperview];
                    break;
                }
            }
            break;
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
