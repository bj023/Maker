//
//  ShopDiscountViewController.m
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopDiscountViewController.h"

#import "GoodsTableViewCell.h"
#import "ShopDataManager.h"
#import "WebViewController.h"

static CGFloat const kCellHeight = 260.0f;

static NSString *const kShopDiscountCellIdentifier = @"ShopDiscountCellIdentifier";

@interface ShopDiscountViewController ()

@property(nonatomic, strong) NSMutableArray *products;

@end

@implementation ShopDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kShopDiscountCellIdentifier];
    
    
    self.products = [NSMutableArray arrayWithArray:[ShopDataManager discountItemFrom:nil shopID:self.shopID count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
        if (data) {
            self.products = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        
    }]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WEAKSELF(weakSelf);
    [self addInfiniteScrollingWithActionHandler:^{
        [ShopDataManager discountItemFrom:[weakSelf.products lastObject] shopID:weakSelf.shopID count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
            if (data) {
                if (weakSelf.products) {
                    [weakSelf.products addObjectsFromArray:data];
                }else{
                    weakSelf.products = [NSMutableArray arrayWithArray:data];
                }
                [weakSelf.tableView reloadData];
                
            }
            [weakSelf stopInfiniteScrollingAnimation];
            
        }];
    }];
}

- (void)setProducts:(NSMutableArray *)products {
    _products = products;
    
    if (_products.count > 0) {
        [self clearEmptyBackground];
    }
    else {
        [self loadEmptyBackgroundWithTitle:@"还没有活动数据" image:[UIImage imageNamed:@"shop_discount_empty"]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.products count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopDiscountCellIdentifier forIndexPath:indexPath];
    ShopDiscount *productInfo = self.products[indexPath.row];
    
    if (productInfo.brand.length) {
        cell.nameLabel.text = productInfo.brand;
        cell.contentLabel.text = productInfo.title;
    }else{
        cell.nameLabel.text = productInfo.title;
        cell.contentLabel.text = nil;
    }
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:productInfo.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    
//    cell.discount = [productInfo[@"discount"] integerValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 商店的折扣
    ShopDiscount *productInfo = self.products[indexPath.row];
    WebViewController *controller = [[WebViewController alloc] initWithURLString:productInfo.detail_url];
    controller.type = [productInfo.type integerValue];
    controller.itemID = productInfo.eventID;

    SSLog(@"ShopDiscountViewController-%@",controller.itemID);

    
    [self.parentViewController pushViewControllerInNavgation:controller animated:YES];
}

@end
