//
//  ShopSearchResultsController.m
//  Discount
//
//  Created by jackyzeng on 3/10/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopSearchResultsController.h"
#import "ShopSearchViewCell.h"
#import "ShopBrandViewController.h"

#import "ShopBrandLetterInfo.h"
#import "NetAPI.h"

static NSString *const kSearchCellIdentifier = @"SearchCellIdentifier";

@interface ShopSearchResultsController ()

@property(nonatomic) BOOL shouldRequestProducts;
@property(nonatomic, strong) NSNumber *categoryID;
@property(nonatomic, strong) NSArray *bridgeProducts;

@end

@implementation ShopSearchResultsController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupBackItem];
        
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopSearchViewCell" bundle:nil] forCellReuseIdentifier:kSearchCellIdentifier];
    
    WEAKSELF(weakSelf);
    if (self.shouldRequestProducts) {
        AFHTTPRequestOperation *op = [NetAPI operationForBrandListByShopID:self.shopID
                                                                inCategory:self.categoryID
                                                                   success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                                                                       weakSelf.bridgeProducts = data[@"data"];
                                                                       [self.tableView reloadData];
                                                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                       // TODO(jacky):handle failure
                                                                   }];
        
        [op start];
    }
}

- (void)needRequestProductsFromShop:(NSNumber *)shopID inCategory:(NSNumber *)categoryID {
    self.shouldRequestProducts = YES;
    
    self.shopID = shopID;
    self.categoryID = categoryID;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shouldRequestProducts) {
        return self.bridgeProducts.count;
    }
    
    return self.allProducts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    ShopSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCellIdentifier forIndexPath:indexPath];
    if (self.shouldRequestProducts) {
        cell.nameLabel.text = self.bridgeProducts[row][@"brand_name"];
    }
    else {
        cell.nameLabel.text = [self.allProducts[row] brandName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ShopBrandViewController *brand = [ShopBrandViewController new];
    if (self.shouldRequestProducts) {
        brand.brandID = self.bridgeProducts[indexPath.row][@"brand_id"];
    }
    else {
        brand.brandID = [self.allProducts[indexPath.row] brandId];
    }
    brand.shopID = self.shopID;
    [self pushViewControllerInNavgation:brand animated:YES];
}

@end
