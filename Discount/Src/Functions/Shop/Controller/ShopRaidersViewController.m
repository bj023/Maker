//
//  ShopRaidersViewController.m
//  Discount
//
//  Created by jackyzeng on 3/8/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopRaidersViewController.h"
#import "ShopRaidersCell.h"
#import "ShopDataManager.h"
#import "WebViewController.h"

static CGFloat const kCellHeight = 200.0f;
static NSString *const kShopRaidersCellIdentifier = @"ShopRaidersCellIdentifier";

@interface ShopRaidersViewController ()

@property(nonatomic, strong) NSMutableArray *tableDatas;

@end

@implementation ShopRaidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopRaidersCell" bundle:nil] forCellReuseIdentifier:kShopRaidersCellIdentifier];
    
    self.tableDatas = [NSMutableArray arrayWithArray:[ShopDataManager raidersItemFrom:nil shopID:self.shopID count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
        if (!error && data) {

            self.tableDatas = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        
    }]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WEAKSELF(weakSelf);
    [self addInfiniteScrollingWithActionHandler:^{
        [ShopDataManager raidersItemFrom:[weakSelf.tableDatas lastObject] shopID:weakSelf.shopID count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
            if (data) {
                if (weakSelf.tableDatas) {
                    [weakSelf.tableDatas addObjectsFromArray:data];
                }else{
                    weakSelf.tableDatas = [NSMutableArray arrayWithArray:data];
                }
                [weakSelf.tableView reloadData];
                
            }
            [weakSelf stopInfiniteScrollingAnimation];
            
        }];
    }];
}


- (void)setTableDatas:(NSMutableArray *)tableDatas {
    _tableDatas = tableDatas;
    
    if (_tableDatas.count > 0) {
        [self clearEmptyBackground];
    }
    else {
        [self loadEmptyBackgroundWithTitle:@"还没有攻略数据" image:[UIImage imageNamed:@"shop_raiders_empty"]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopRaidersCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopRaidersCellIdentifier forIndexPath:indexPath];
   
    ShopRebate *rebate = self.tableDatas[indexPath.row];
    
    cell.contentLabel.text = rebate.title;
    [cell.raidersImageView sd_setImageWithURL:[NSURL URLWithString:rebate.imageUrl]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SSLog(@"raiders select cell at indexpath(%d, %d)", (int)indexPath.section, (int)indexPath.row);
    
    ShopRebate *rebate = self.tableDatas[indexPath.row];
    WebViewController *controller = [[WebViewController alloc] initWithURLString:rebate.detail_url];
    controller.type     = [rebate.type integerValue];
    controller.liked    = [rebate.favorite boolValue];
    controller.itemID   = rebate.guideID;

    SSLog(@"ShopRaidersViewController-%@",controller.itemID);


    [self.parentViewController pushViewControllerInNavgation:controller animated:YES];
}

@end
