//
//  FavBaseTableViewController.h
//  Discount
//
//  Created by fengfeng on 15/4/11.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NetAPI.h"

@class LikeButton;

@interface FavBaseTableViewController : BaseTableViewController

@property(nonatomic, retain) NSMutableArray *dataSource;
@property(nonatomic, assign) OpertationItemType opType;
@property(nonatomic, retain) NSString *cellIdentify;
@property(nonatomic, retain) NSString *cellXibName;
@property(nonatomic, assign) NSNumber *type;

- (void)likeButtonPress:(LikeButton *)sender;

@end
