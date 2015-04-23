//
//  DestinationTableViewCell.m
//  Discount
//
//  Created by fengfeng on 15/3/10.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "DestinationTableViewCell.h"
#import "DestinationShopTableViewCell.h"
#import "HomeBournShop.h"
#import "ShopHomeViewController.h"
#import "ShopNewProductViewController.h"
#import "ShopSearchViewController.h"
#import "ShopDiscountViewController.h"
#import "ShopRaidersViewController.h"
#import "ShopRebateViewController.h"
#import "ShopGuidesViewController.h"
#import "ShopViewController.h"

@interface DestinationTableViewCell () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;

@end


@implementation DestinationTableViewCell

- (void)awakeFromNib {
    
    self.shopTableView.dataSource   = self;
    self.shopTableView.delegate     = self;
    self.shopTableView.tableFooterView = [UIView new];
    
    [self.shopTableView registerNib:[UINib nibWithNibName:@"DestinationShopTableViewCell" bundle:nil] forCellReuseIdentifier:DestinationShopTableViewCellIdentifier];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)reload
{
    [self.shopTableView reloadData];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DestinationShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DestinationShopTableViewCellIdentifier forIndexPath:indexPath];
    HomeBournShop *shop = self.dataSource[indexPath.row];
    cell.shopDiscount.hidden = [shop.isDiscount boolValue]? NO:YES;
    cell.shopName.text = shop.shopName;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeBournShop *shop = self.dataSource[indexPath.row];
    
    [self.viewController goShopViewControllerWithId:shop.shopID];
}

@end
