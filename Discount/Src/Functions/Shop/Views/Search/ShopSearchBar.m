//
//  ShopSearchBar.m
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopSearchBar.h"

@interface ShopSearchBar ()

@property(nonatomic) UITextField *searchField;

- (void)customUI;

@end

@implementation ShopSearchBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self customUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customUI];
    }
    
    return self;
}

- (UITextField *)findSearchField {
    UITextField *searchField;
    for (UIView *subview in self.subviews)
    {
        
        //this will work in iOS 7
        for (id sub in subview.subviews) {
            if([NSStringFromClass([sub class]) isEqualToString:@"UISearchBarTextField"])
            {
                [sub setTextAlignment:NSTextAlignmentRight];
            }
        }
        //this will work for less than iOS 7
        if ([subview isKindOfClass:[UITextField class]]) {
            searchField = (UITextField *)subview;
            break;
        }
    }
    //for less than iOS 7
    if (searchField) {
        searchField.textAlignment = NSTextAlignmentRight;
    }

    return searchField;
}

- (void)customUI {
    self.searchField = [self findSearchField];
    
    // change text color
    [[UITextField appearanceWhenContainedIn:[self class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    self.placeholder = @"搜索品牌（英文）";
    
    [self setImage:[UIImage imageNamed:@"common_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

@end
