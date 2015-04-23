//
//  PullRefreshTableViewController.m
//  Discount
//
//  Created by fengfeng on 15/3/25.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "PullRefreshTableViewController.h"

@implementation PullRefreshTableViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WEAKSELF(weakSelf)
    [self addPullToRefreshWithActionHandler:^{
        [weakSelf refreshForAllData];
    }];
    
    [self addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshForMoreData];
    }];
}


- (void)refreshForAllData
{
    SSLog(@"refreshForAllData");
}

- (void)refreshForMoreData
{
    
}

@end
