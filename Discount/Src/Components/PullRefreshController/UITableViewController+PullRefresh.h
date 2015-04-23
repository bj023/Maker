//
//  UITableViewController+PullRefresh.h
//  Discount
//
//  Created by fengfeng on 15/3/23.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewController (PullRefresh)

// 不能在loadview 添加，控件有bug
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)stopPullAnimation;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)stopInfiniteScrollingAnimation;

@end
