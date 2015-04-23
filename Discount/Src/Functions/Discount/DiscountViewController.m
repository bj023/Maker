//
//  DiscountViewController.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "DiscountViewController.h"
#import "HomeTableViewCell.h"
#import "HomeDataManager.h"
#import "HomeDiscount.h"
#import "HomeTableViewCell.h"
#import "WebViewController.h"

#import "ShopHomeViewController.h"
#import "ShopNewProductViewController.h"
#import "ShopDiscountViewController.h"
#import "ShopSearchViewController.h"
#import "ShopRaidersViewController.h"
#import "ShopGuidesViewController.h"
#import "ShopRebateViewController.h"
#import "ShopViewController.h"

@interface DiscountViewController ()
@property(nonatomic, retain) NSMutableArray  *dataSource;

@end

@implementation DiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:HomeTableViewIdentifier];
    self.tableView.rowHeight =  290;
    
    
    self.dataSource = [NSMutableArray arrayWithArray:[HomeDataManager disCountItemFrom:0 count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
        if (!error && data) {
            self.dataSource = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }]] ;
    
    if (!self.dataSource.count) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeTableViewCell *productCell = [tableView dequeueReusableCellWithIdentifier:HomeTableViewIdentifier forIndexPath:indexPath];
    
    HomeDiscount *discount = self.dataSource[indexPath.row];
    [productCell.productImage sd_setImageWithURL:[NSURL URLWithString:discount.imageUrl]
                                placeholderImage:[UIImage imageNamed:@""]];
    
    if (discount.brand.length) {
        productCell.productDetail.text = discount.title;
        productCell.productName.text   = discount.brand;
    }else{
        productCell.productDetail.text = @"";
        productCell.productName.text = discount.title;
    }
    
    productCell.addressName.text   =  [NSString stringWithFormat:@"%@-%@", discount.region ,discount.city];
    
    [productCell.shopName setTitle:discount.shopName forState:UIControlStateNormal];
//    [productCell.shopName addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    productCell.productDiscont.image = [discount.isDiscount integerValue] != 0 ? [UIImage imageNamed:@"home_cell_exclusive"] : nil;
    
    [self configShopNameButton:productCell.shopName with:discount];
    
    return productCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HomeDiscount *discount = self.dataSource[indexPath.row];

    WebViewController *controller = [[WebViewController alloc] initWithURLString:discount.detail_url];
    
    
    controller.type = [discount.type integerValue];
    controller.itemID = discount.eventID;

    SSLog(@"活动：DiscountViewController-%@",controller.itemID);
    
    [self pushViewControllerInNavgation:controller animated:YES];
}

#pragma mark -

- (void)configShopNameButton:(UIShopNameButton *)shopName with:(HomeDiscount *)recommend
{
    [shopName setTitle:recommend.shopName forState:UIControlStateNormal];
    [shopName addTarget:self action:@selector(shopNameClick:) forControlEvents:UIControlEventTouchUpInside];
    shopName.shopID = recommend.shopID;
}

- (void)shopNameClick:(UIShopNameButton *)button
{
    [self goShopViewControllerWithId:button.shopID];
}

#pragma mark - pull refresh

- (void)refreshForAllData
{
    [super refreshForAllData];
    
    [HomeDataManager disCountItemFrom:0 count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
        if (!error && data) {
            self.dataSource = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        
        [self stopPullAnimation];
        
    }];
    
    
}

- (void)refreshForMoreData
{
    [super refreshForMoreData];
    
    [HomeDataManager disCountItemFrom:[self.dataSource lastObject] count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
        if (data) {
            if (self.dataSource) {
                [self.dataSource addObjectsFromArray:data];
            }else{
                self.dataSource = [NSMutableArray arrayWithArray:data];
            }
            [self.tableView reloadData];
            
        }
        [self stopInfiniteScrollingAnimation];
        
    }];
    
}

@end
