//
//  PullRefreshTableViewController.h
//  Discount
//
//  Created by fengfeng on 15/3/25.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PullRefreshTableViewController : BaseTableViewController

- (void)refreshForAllData;
- (void)refreshForMoreData;
@end
