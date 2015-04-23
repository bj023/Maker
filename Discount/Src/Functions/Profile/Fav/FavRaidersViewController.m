//
//  FavRaidersViewController.m
//  Discount
//
//  Created by fengfeng on 15/4/9.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "FavRaidersViewController.h"
#import "GuidTableViewCell.h"
#import "ProDataManager.h"
#import "FavGuid.h"

static NSString *const kGuidIdentifier       = @"kGuidIdentifier";

@interface FavRaidersViewController ()

@end



@implementation FavRaidersViewController


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        self.cellXibName    = @"GuidTableViewCell";
        self.cellIdentify   = kGuidIdentifier;
        self.opType         = OpertationItemType_FavGuid;
        self.type           = @(2);
    }
    
    return self;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [self.tableView registerNib:[UINib nibWithNibName:@"GuidTableViewCell" bundle:nil] forCellReuseIdentifier:kGuidIdentifier];
//    
//    self.tableView.rowHeight = 90;
//    self.tableView.tableFooterView = [UIView new];
//    
//    self.dataSource = [NSMutableArray arrayWithArray:[ProDataManager itemInfoForType:OpertationItemType_FavGuid From:nil op:OpertationType_PullToRefresh count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
//        
//        if (data) {
//            self.dataSource = [NSMutableArray arrayWithArray:data];
//            [self.tableView reloadData];
//        }
//        
//    }]];
//}
//
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    WEAKSELF(weakSelf)
//    
//    [self addInfiniteScrollingWithActionHandler:^{
//        [ProDataManager itemInfoForType:OpertationItemType_FavGuid From:[weakSelf.dataSource lastObject] op:OpertationType_InfiniteScroll count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
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
    
    FavGuid *favGuid = self.dataSource[indexPath.row];
    GuidTableViewCell *guidCell = [tableView dequeueReusableCellWithIdentifier:kGuidIdentifier forIndexPath:indexPath];
    [guidCell.thumb sd_setImageWithURL:[NSURL URLWithString:favGuid.thumb] placeholderImage:[UIImage imageNamed:@""]];
    
    guidCell.likeButton.item = favGuid;
    [guidCell.likeButton addTarget:self action:@selector(likeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    guidCell.title.text = favGuid.title;
    guidCell.region.text = ADDRSTRBY(favGuid.region, favGuid.city);//  favGuid.region;
    guidCell.shopName.text = favGuid.shopName;

    
    return guidCell;
    
}

@end
