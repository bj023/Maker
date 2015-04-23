//
//  ShopSearchListViewController.m
//  Discount
//
//  Created by jackyzeng on 3/10/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopSearchListViewController.h"
#import "ShopBrandViewController.h"
#import "ShopSearchViewCell.h"

static NSString *const kShopSearchListCellIdentifier = @"ShopSearchListCellIdentifier";

@interface ShopSearchListViewController ()

@property(nonatomic, strong) NSMutableArray *allProducts;

@end

@implementation ShopSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.allProducts = [[NSMutableArray alloc]
                        initWithArray:@[@"A Diciannovenventitre",
                                        @"A Line",
                                        @"A Question of",
                                        @"A-Style",
                                        @"A-Z Collection",
                                        @"A.J. Mogan",
                                        @"A. Kurts",
                                        @"Baelon",
                                        @"Boooooomb",
                                        @"Sharp",
                                        @"Shadow",
                                        @"Xman",
                                        @"Zerg"]];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopSearchViewCell" bundle:nil] forCellReuseIdentifier:kShopSearchListCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allProducts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopSearchListCellIdentifier forIndexPath:indexPath];
    
    cell.nameLabel.text = self.allProducts[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopBrandViewController *brand = [ShopBrandViewController new];;
    [self pushViewControllerInNavgation:brand animated:YES];
}

@end
