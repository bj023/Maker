//
//  UIViewController+GoShop.m
//  Discount
//
//  Created by jackyzeng on 4/10/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "UIViewController+GoShop.h"
#import "ShopHomeViewController.h"
#import "ShopNewProductViewController.h"
#import "ShopSearchViewController.h"
#import "ShopDiscountViewController.h"
#import "ShopRaidersViewController.h"
#import "ShopRebateViewController.h"
#import "ShopGuidesViewController.h"
#import "ShopViewController.h"
#import "NetAPI.h"

@implementation UIViewController (GoShop)

- (void)goShopViewControllerWithId:(NSNumber *)shopId {
    [self goShopViewControllerWithId:shopId type:ShopTypeHome];
}

- (void)goShopViewControllerWithId:(NSNumber *)shopId type:(ShopType)type {
    [self goShopViewControllerWithId:shopId type:type animated:YES];
}

- (void)goShopViewControllerWithId:(NSNumber *)shopId type:(ShopType)type animated:(BOOL)animated {
    if (shopId == nil) {
        return;
    }
        
    if (type < ShopTypeHome || type > ShopTypeRebate) {
        type = ShopTypeHome;
    }
    

    AFHTTPRequestOperation *op = [NetAPI operationForShopInfoByShopID:shopId success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        SSLog(@"%@",[[data objectForKey:@"data"] objectForKey:@"tabs"]);
        
        NSArray *tabs = [[data objectForKey:@"data"] objectForKey:@"tabs"];
        
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (NSDictionary *dic in tabs) {
            NSNumber *index = [dic objectForKey:@"id"];
            NSString *title = [dic objectForKey:@"name"];
            switch (index.intValue) {
                case 1:
                {
                    ShopHomeViewController *home = [ShopHomeViewController new];
                    home.shopID =shopId;
                    home.title = title;
                    [viewControllers addObject:home];
                }
                    break;
                case 2:
                {
                    ShopNewProductViewController *product = [ShopNewProductViewController new];
                    product.shopID =shopId;
                    product.title = title;
                    [viewControllers addObject:product];
                }
                    break;
                case 3:
                {
                    ShopDiscountViewController *discount = [ShopDiscountViewController new];
                    discount.shopID =shopId;
                    discount.title = title;
                    [viewControllers addObject:discount];
                }
                    break;
                case 4:
                {
                    ShopSearchViewController *search = [ShopSearchViewController new];
                    search.shopID = shopId;
                    search.title = title;
                    [viewControllers addObject:search];
                }
                    break;
                case 5:
                {
                    ShopRaidersViewController *raiders = [ShopRaidersViewController new];
                    raiders.shopID = shopId;
                    raiders.title = title;
                    [viewControllers addObject:raiders];
                }
                    break;
                case 6:
                {
                    ShopGuidesViewController *guide = [ShopGuidesViewController new];
                    guide.shopID = shopId;
                    guide.title = title;
                    [viewControllers addObject:guide];
                }
                    break;
                case 7:
                {
                    ShopRebateViewController *rebate = [ShopRebateViewController new];
                    rebate.shopID = shopId;
                    rebate.title = title;
                    [viewControllers addObject:rebate];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        ShopViewController *shopViewController = [[ShopViewController alloc] initWithViewControllers:viewControllers selectAt:type];

        [self pushViewControllerInNavgation:shopViewController animated:animated];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [op start];
//    ShopHomeViewController *home = [ShopHomeViewController new];
//    home.shopID =shopId;
//
//    ShopNewProductViewController *product = [ShopNewProductViewController new];
//    product.shopID =shopId;
//
//    ShopDiscountViewController *discount = [ShopDiscountViewController new];
//    discount.shopID =shopId;
//
//    ShopSearchViewController *search = [ShopSearchViewController new];
//    search.shopID = shopId;
//
//    ShopRaidersViewController *raiders = [ShopRaidersViewController new];
//    raiders.shopID = shopId;
//
//    ShopGuidesViewController *guide = [ShopGuidesViewController new];
//    guide.shopID = shopId;
//
//    ShopRebateViewController *rebate = [ShopRebateViewController new];
//    rebate.shopID = shopId;
//
//    home.title = @"首页";
//    product.title = @"新品";
//    discount.title = @"活动";
//    search.title = @"查牌";
//    raiders.title = @"攻略";
//    guide.title = @"地图";
//    rebate.title = @"退税";
//    
//    //商店跳转->
//    NSArray *viewControllers = @[home, product, discount, search, raiders, guide, rebate];
//    ShopViewController *shopViewController = [[ShopViewController alloc] initWithViewControllers:viewControllers selectAt:type];
//    [self pushViewControllerInNavgation:shopViewController animated:animated];
}

@end
