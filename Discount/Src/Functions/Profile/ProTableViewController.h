//
//  ProTableViewController.h
//  Discount
//
//  Created by bilsonzhou on 15/3/25.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NetAPI.h"


@interface ProTableViewController : BaseTableViewController

- (void)getInitData;

@property(nonatomic, retain) NSMutableArray  *dataSource;
@property(nonatomic, assign) OpertationItemType opType;
@end
