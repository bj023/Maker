//
//  ShopSearchResultsController.h
//  Discount
//
//  Created by jackyzeng on 3/10/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopBaseTableViewController.h"

@interface ShopSearchResultsController : ShopBaseTableViewController

@property(nonatomic, strong) NSArray *allProducts;

// list in category API
- (void)needRequestProductsFromShop:(NSNumber *)shopID inCategory:(NSNumber *)categoryID;

@end
