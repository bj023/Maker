//
//  MenuFavViewController.m
//  Discount
//
//  Created by jackyzeng on 4/13/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "MenuFavViewController.h"

#import "FavNewProductViewController.h"
#import "FavShopViewController.h"
#import "FavRaidersViewController.h"

@interface MenuFavViewController ()

@end

@implementation MenuFavViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    FavShopViewController *shop = [FavShopViewController new];
    FavNewProductViewController *product = [FavNewProductViewController new];
    FavRaidersViewController *raiders = [FavRaidersViewController new];
    shop.title = @"商场";
    product.title = @"新品";
    raiders.title = @"攻略";
    NSArray *viewControllers = @[shop, product, raiders];
    
    if (self = [super initWithViewControllers:viewControllers]) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"喜欢";
    [self removeBackItem];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
