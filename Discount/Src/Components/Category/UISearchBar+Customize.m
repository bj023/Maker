//
//  UISearchBar+Customize.m
//  Discount
//
//  Created by jackyzeng on 3/28/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "UISearchBar+Customize.h"

NSString *searchBarHackingPlaceholder() {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    // iPhone 4, 4s, 5, 5s
    if (screenBounds.size.width <= 320) {
        return @"搜索品牌（英文）                              ";
    }
    // iPhone 6
    else if (screenBounds.size.width <=375) {
        return @"搜索品牌（英文）                                          ";
    }
    // iPhone 6 Plus
    return @"搜索品牌（英文）                                                        ";
}

@implementation UISearchBar (Customize)

- (void)customizeSearchBarApperance {
    UISearchBar *searchBar = self;
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_search"]];
    searchField.leftView = imageView;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    [searchField setBorderStyle:UITextBorderStyleNone];
    searchField.backgroundColor = [UIColor whiteColor];
}

@end
