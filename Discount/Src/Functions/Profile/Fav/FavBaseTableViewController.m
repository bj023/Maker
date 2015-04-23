//
//  FavBaseTableViewController.m
//  Discount
//
//  Created by fengfeng on 15/4/11.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "FavBaseTableViewController.h"
#import "ProDataManager.h"
#import "LikeButton.h"
#import "HomeDataManager.h"
#import "WebViewController.h"

@implementation FavBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:self.cellXibName bundle:nil] forCellReuseIdentifier:self.cellIdentify];
    
    self.tableView.rowHeight = 90;
    self.tableView.tableFooterView = [UIView new];
    
    self.dataSource = [NSMutableArray arrayWithArray:[ProDataManager itemInfoForType:self.opType From:nil op:OpertationType_PullToRefresh count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
        if (data) {
            self.dataSource = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        
    }]];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    WEAKSELF(weakSelf)
    
    [self addInfiniteScrollingWithActionHandler:^{
        [ProDataManager itemInfoForType:weakSelf.opType From:[weakSelf.dataSource lastObject] op:OpertationType_InfiniteScroll count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
            
            if (data) {
                if (weakSelf.dataSource) {
                    [weakSelf.dataSource addObjectsFromArray:data];
                }else{
                    weakSelf.dataSource = [NSMutableArray arrayWithArray:data];
                }
                [weakSelf.tableView reloadData];
                
            }
            [weakSelf stopInfiniteScrollingAnimation];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemBaseInfo *item = self.dataSource[indexPath.row];
    
    if ([self.type integerValue] == 4) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.parentViewController goShopViewControllerWithId:item.targetID];
    }else{
        
        WebViewController *controller = [[WebViewController alloc] initWithURLString:item.detail_url];
        controller.liked = [item.favorite boolValue];
        controller.type = [self.type integerValue];
        controller.itemID = item.targetID;

        SSLog(@"FavBaseTableViewController-%@",controller.itemID);

        
        [self.parentViewController pushViewControllerInNavgation:controller animated:YES];
    }
    
}

- (void)likeButtonPress:(LikeButton *)sender
{
    ItemBaseInfo* item = (ItemBaseInfo*)sender.item;
    item.type = self.type;
    //服务器用targetID
    item.guideID    = item.targetID;
    item.shopID     = item.targetID;
    
    [HomeDataManager likeWithItem:item result:^(id data, NSError *error) {
        if (data) {
            item.favorite = @(![item.favorite boolValue]);
            [self updateLikeButton:sender item:item];
        }
    }];
}

- (void)updateLikeButton:(UIButton *)button item:(ItemBaseInfo*)item
{
    BOOL isLike = [item.favorite boolValue];
    UIImage *image = nil;
    
    if (!isLike) {
        image = [UIImage imageNamed:@"common_like"];
    }else{
        image = [UIImage imageNamed:@"common_liked"];
    }
    
    [button setImage:image forState:UIControlStateNormal];
    
}

@end
