//
//  ShopViewController.h
//  Discount
//
//  Created by jackyzeng on 3/4/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopBaseViewController.h"
#import "ShopViewSwitcher.h"

@interface ShopViewController : ShopBaseViewController

@property(nonatomic, strong) IBOutlet ShopViewSwitcher *switcher;
@property(nonatomic, strong) NSArray *viewControllers;
@property(nonatomic, strong) UIViewController *topViewController;
@property(nonatomic) BOOL hasMoreMessage;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers selectAt:(NSInteger)index;

@end
