//
//  FavShopViewController.m
//  Discount
//
//  Created by fengfeng on 15/4/9.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "FavShopViewController.h"
#import "ShopTableViewCell.h"
#import "ProDataManager.h"
#import "FavShop.h"

static NSString *const kShopCellIdentifier   = @"kShopCellIdentifier";

@interface FavShopViewController ()


@end


@implementation FavShopViewController


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        self.cellXibName    = @"ShopTableViewCell";
        self.cellIdentify   = kShopCellIdentifier;
        self.opType         = OpertationItemType_FavShop;
        self.type           = @(4);
    }
    
    return self;
}


//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [self.tableView registerNib:[UINib nibWithNibName: bundle:nil] forCellReuseIdentifier:kShopCellIdentifier];
//    
//    self.tableView.rowHeight = 90;
//    self.tableView.tableFooterView = [UIView new];
//    
//    self.dataSource = [NSMutableArray arrayWithArray:[ProDataManager itemInfoForType:OpertationItemType_FavShop From:nil op:OpertationType_PullToRefresh count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
//        
//        if (data) {
//            self.dataSource = [NSMutableArray arrayWithArray:data];
//            [self.tableView reloadData];
//        }
//        
//    }]];
//}


//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    WEAKSELF(weakSelf)
//    
//    [self addInfiniteScrollingWithActionHandler:^{
//        [ProDataManager itemInfoForType:OpertationItemType_FavShop From:[weakSelf.dataSource lastObject] op:OpertationType_InfiniteScroll count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
//            
//            if (data) {
//                if (weakSelf.dataSource) {
//                    [weakSelf.dataSource addObjectsFromArray:data];
//                }else{
//                    weakSelf.dataSource = [NSMutableArray arrayWithArray:data];
//                }
//                [weakSelf.tableView reloadData];
//                
//            }
//            [weakSelf stopInfiniteScrollingAnimation];
//        }];
//    }];
//}


#pragma mark - tableview

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataSource.count;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FavShop *favShop = self.dataSource[indexPath.row];
    ShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:kShopCellIdentifier forIndexPath:indexPath];
    shopCell.nameLable.text = favShop.name;
    shopCell.region.text = ADDRSTRBY(favShop.region, favShop.city);
    [shopCell.logImgView sd_setImageWithURL:[NSURL URLWithString:favShop.logoUrl] placeholderImage:[UIImage imageNamed:@""]];
    
  
    shopCell.likeButton.item = favShop;
    [shopCell.likeButton addTarget:self action:@selector(likeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    return shopCell;
    
}


@end
