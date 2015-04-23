//
//  FavNewProductViewController.m
//  Discount
//
//  Created by fengfeng on 15/4/9.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "FavNewProductViewController.h"
#import "GoodTableViewCell.h"
#import "ProDataManager.h"
#import "HomeDataManager.h"
#import "FavGood.h"


static NSString *const kNewGoodIdentifier    = @"kNewGoodIdentifier";

@interface FavNewProductViewController ()



@end


@implementation FavNewProductViewController


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        self.cellXibName    = @"GoodTableViewCell";
        self.cellIdentify   = kNewGoodIdentifier;
        self.opType         = OpertationItemType_FavGood;
        self.type           = @(3);
    }
    
    return self;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:kNewGoodIdentifier];;
//    
//    self.tableView.rowHeight = 90;
//
//    self.tableView.tableFooterView = [UIView new];
//    
//    self.dataSource = [NSMutableArray arrayWithArray:[ProDataManager itemInfoForType:OpertationItemType_FavGood From:nil op:OpertationType_PullToRefresh count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
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
//        [ProDataManager itemInfoForType:OpertationItemType_FavGood From:[weakSelf.dataSource lastObject] op:OpertationType_InfiniteScroll count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
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
    
    FavGood *favGood = self.dataSource[indexPath.row];
    GoodTableViewCell *goodCell = [tableView dequeueReusableCellWithIdentifier:kNewGoodIdentifier forIndexPath:indexPath];
    [goodCell.thumb sd_setImageWithURL:[NSURL URLWithString:favGood.thumb] placeholderImage:[UIImage imageNamed:@""]];
    goodCell.brand.text = favGood.brand;
    goodCell.name.text = favGood.name;
    goodCell.region.text = ADDRSTRBY(favGood.region, favGood.city);
//    goodCell.city.text = favGood.city;
    goodCell.shopName.text = favGood.shopName;
    goodCell.likeButton.item = favGood;
    [goodCell.likeButton addTarget:self action:@selector(likeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return goodCell;
    
}




#pragma mark - private

//- (void)likeButtonPress:(LikeButton *)sender
//{
//    ItemBaseInfo* item = (ItemBaseInfo*)sender.item;
//    item.type = se;
//    
//    
//    [HomeDataManager likeWithItem:item result:^(id data, NSError *error) {
//        if (data) {
//            item.favorite = @(![item.favorite boolValue]);
//            [self updateLikeButton:sender item:item];
//        }
//    }];
//}
//
//- (void)updateLikeButton:(UIButton *)button item:(ItemBaseInfo*)item
//{
//    BOOL isLike = [item.favorite boolValue];
//    UIImage *image = nil;
//    
//    if (!isLike) {
//        image = [UIImage imageNamed:@"common_like"];
//    }else{
//        image = [UIImage imageNamed:@"profile_like"];
//    }
//        
//    [button setImage:image forState:UIControlStateNormal];
//    
//}


@end
