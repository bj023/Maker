//
//  NewProductViewController.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "NewProductViewController.h"
#import "NewProductTableViewCell.h"
#import "HomeDataManager.h"
#import "HomeNewProduct.h"
#import "ShopProductDetailViewController.h"
#import "ShopHomeViewController.h"
#import "ShopNewProductViewController.h"
#import "ShopDiscountViewController.h"
#import "ShopSearchViewController.h"
#import "ShopRaidersViewController.h"
#import "ShopGuidesViewController.h"
#import "ShopRebateViewController.h"
#import "ShopViewController.h"
#import "ProfileDataManager.h"
#import "UIImage+ImageWithColor.h"
#import "UIViewController+loginHelper.h"
#import "WebViewController.h"

@interface NewProductViewController ()
@property(nonatomic, retain) NSMutableArray  *dataSource;
@end

@implementation NewProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewProductTableViewCell" bundle:nil] forCellReuseIdentifier:NewProductTableViewCellIndentifier];
    
    self.tableView.rowHeight = 340;
    
    self.dataSource = [NSMutableArray arrayWithArray:[HomeDataManager newProductItemFrom:0 count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count % 2 == 0) {
        return self.dataSource.count/2;
    }
    return self.dataSource.count/2 + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewProductTableViewCellIndentifier forIndexPath:indexPath];
    
    HomeNewProduct *newProduct = self.dataSource[indexPath.row * 2];
    [self updateProductInfo:cell.left withData:newProduct];
    
    if (indexPath.row * 2 + 1 >= self.dataSource.count) {
        cell.right.hidden = YES;
    }else{
        cell.right.hidden = NO;
        newProduct = self.dataSource[indexPath.row * 2 + 1];
        [self updateProductInfo:cell.right withData:newProduct];
    }
    
    
    return cell;
    
}


#pragma mark - private
- (void)updateProductInfo:(NewProductInfoView *)view withData:(HomeNewProduct *)newProduct
{
    view.brand.text    = newProduct.brand;
    view.name.text     = newProduct.name;
    view.price1.price  = [NSString stringWithFormat:@"%@",newProduct.price1];
    view.price2.price  = [NSString stringWithFormat:@"%@",newProduct.price2];
    
    view.address.text = [NSString stringWithFormat:@"%@-%@", newProduct.region, newProduct.city];
    [view.shopName setTitle:newProduct.shopName forState:UIControlStateNormal];
    view.shopName.shopID = newProduct.shopID;
    [view.shopName addTarget:self action:@selector(shopNameClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view.productImageView sd_setImageWithURL:[NSURL URLWithString:newProduct.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productSelected:)];
    [view addGestureRecognizer:gesture];
    
    
    view.likeButton.item = newProduct;
    [view.likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateLikeButton:view.likeButton item:newProduct];
    
    view.item = newProduct;
}


- (void)updateLikeButton:(UIButton *)button item:(ItemBaseInfo*)item
{
    BOOL isLike = [item.favorite boolValue];
    UIImage *image = nil;
 
    if (!isLike) {
        image = [UIImage imageNamed:@"common_like_40pt"];
    }else{
        image = [UIImage imageNamed:@"common_liked_40pt"];
    }
    
    UIImage *bgImage = [UIImage imageWithColor:SS_RGBAColor(127,127,127,0.5)];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    
}

- (void)likeAction:(LikeButton *)sender
{
    ItemBaseInfo* item = (ItemBaseInfo*)sender.item;
    
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    
    if (!userInfo.isLogin) {
        [self showLoginViewController];
        return;
    }
    item.type = @(3);
    [HomeDataManager likeWithItem:item result:^(id data, NSError *error) {
        if (data) {
            item.favorite = @(![item.favorite boolValue]);
            [self updateLikeButton:sender item:item];
        }
    }];
    
}

- (void)productSelected:(UITapGestureRecognizer *)gesture
{
    NewProductInfoView * view = (NewProductInfoView *)gesture.view;
    ItemBaseInfo *item = view.item;
    
    WebViewController *controller = [[WebViewController alloc] initWithURLString:item.detail_url];
    controller.type     = [item.type integerValue];
    controller.liked    = [item.favorite boolValue];
    controller.itemID   = item.targetID;
    
    SSLog(@"NewProductViewController-%@",controller.itemID);
    
    [self pushViewControllerInNavgation:controller animated:YES];
    
//    ShopProductDetailViewController *detailViewController = [ShopProductDetailViewController new];
//    detailViewController.shopID     = view.shopID;
//    detailViewController.goodsID    = view.goodsID;
//    
//    [self pushViewControllerInNavgation:detailViewController animated:YES];
}


#pragma mark - pull refresh

- (void)refreshForAllData
{
    [super refreshForAllData];
    
    [HomeDataManager newProductItemFrom:0 count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
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
    
    [HomeDataManager newProductItemFrom:[self.dataSource lastObject] count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
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

- (void)shopNameClick:(UIShopNameButton *)button
{
    [self goShopViewControllerWithId:button.shopID];
}

@end
