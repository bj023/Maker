//
//  HomeViewController.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "HomeViewController.h"
#import "ShopViewController.h"
#import "BaseNavigationController.h"
#import "ShopHomeViewController.h"
#import "ShopNewProductViewController.h"
#import "ShopDiscountViewController.h"
#import "ShopSearchViewController.h"
#import "ShopRaidersViewController.h"
#import "ShopGuidesViewController.h"
#import "ShopRebateViewController.h"
#import "HomeTableViewCell.h"
#import "HomeDataManager.h"
//#import "HomeRaidersTableViewCell.h"
#import "HomeRecommend.h"
#import "HomeNewProductTableViewCell.h"
#import "HomeShopTableViewCell.h"
#import "WebViewController.h"
#import "ShopProductDetailViewController.h"
#import "IBDestinationHeaderView.h"
#import "DestinationViewController.h"
#import "UIImage+ImageWithColor.h"
#import "ProfileDataManager.h"
#import "UIViewController+loginHelper.h"
#import "HomeRaidersCell.h"

static CGFloat const kHomeRaidersCellHeight = 232.0f;
static CGFloat const kNewProductCellHeight  = 505.0f;
static CGFloat const kDiscountCellHeight    = 290.0f;
static CGFloat const kShopCellHeight        = 290.0f;

static NSString *const kShopRaidersCellIdentifier   = @"HomeRaidersCell";
static NSString *const kNewProductIdentifier        = @"NewProductCellIdentifier";
static NSString *const kShopIdentifier              = @"kShopIdentifier";


@interface HomeViewController () <DestinationHeaderViewDelegate>

//@property(nonatomic, retain) HomeDataManager *homeDataManager;
@property(nonatomic, retain) NSMutableArray  *dataSource;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:HomeTableViewIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeRaidersCell" bundle:nil] forCellReuseIdentifier:kShopRaidersCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeNewProductTableViewCell" bundle:nil] forCellReuseIdentifier:kNewProductIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeShopTableViewCell" bundle:nil] forCellReuseIdentifier:kShopIdentifier];
    
    
    self.dataSource = [NSMutableArray arrayWithArray:[HomeDataManager recommendItemFrom:nil count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
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
}

#pragma mark - pull refresh

- (void)refreshForAllData
{
    [super refreshForAllData];
    
    [HomeDataManager recommendItemFrom:nil count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        if (data) {
            
            self.dataSource = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        [self stopPullAnimation];
    }];
}

- (void)refreshForMoreData
{
    [super refreshForMoreData];
    [HomeDataManager recommendItemFrom:[self.dataSource lastObject] count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error){
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

#pragma mark - DestinationHeaderViewDelgate

- (void)tabBarToDestionation:(E_DESITION)destination
{
    UITabBarController *tabbarController = self.navigationController.tabBarController;
    DestinationViewController *controller = (DestinationViewController *)[tabbarController.viewControllers[3] viewControllers][0];
    controller.destination = destination;
    [tabbarController setSelectedIndex:3];
}

- (void)view:(IBDestinationHeaderView *)view didSelectDestination:(E_DESITION)destination {
    [self tabBarToDestionation:destination];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeRecommend *recommend = self.dataSource[indexPath.row];
    switch ([recommend.type integerValue]) {
        case 1:
            return kDiscountCellHeight;
        case 2:
            return kHomeRaidersCellHeight;
        case 3:
            return kNewProductCellHeight;
        case 4:
            return kShopCellHeight;
        default:
            return 44;
    }
    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    HomeRecommend *recommend = self.dataSource[indexPath.row];
    
    switch ([recommend.type integerValue]) {
        case 1:
        {
            //
            HomeTableViewCell *productCell = [tableView dequeueReusableCellWithIdentifier:HomeTableViewIdentifier forIndexPath:indexPath];
            
            [productCell.productImage sd_setImageWithURL:[NSURL URLWithString:recommend.imageUrl]
                                        placeholderImage:[UIImage imageNamed:@""]];

            
            productCell.productName.text   = IsEmpty(recommend.brand)?recommend.title:recommend.brand;
            productCell.productDetail.text = IsEmpty(recommend.brand)?@"":recommend.title;
            productCell.addressName.text   =  [NSString stringWithFormat:@"%@-%@", recommend.region ,recommend.city];
            [self configShopNameButton:productCell.shopName width:recommend];
            
            productCell.productDiscont.image = [recommend.isDiscount integerValue] != 0 ? [UIImage imageNamed:@"home_cell_exclusive"] : nil;
            cell = productCell;
            break;
        }
            
        case 2:
        {
            // 攻略
            HomeRaidersCell *raidersCell = [tableView dequeueReusableCellWithIdentifier:kShopRaidersCellIdentifier forIndexPath:indexPath];
            
            raidersCell.contentLabel.text = recommend.title;
            [raidersCell.raidersImageView sd_setImageWithURL:[NSURL URLWithString:recommend.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
            raidersCell.address.text = [NSString stringWithFormat:@"%@-%@", recommend.region ,recommend.city];
            
            [self configShopNameButton:raidersCell.shopName width:recommend];
            
            [raidersCell.likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self updateLikeButton:raidersCell.likeButton item:recommend];
            raidersCell.likeButton.item = recommend;
            
            cell = raidersCell;
            break;
        }
        case 3:
        {
            // 商品
            HomeNewProductTableViewCell *newProductCell = [tableView dequeueReusableCellWithIdentifier:kNewProductIdentifier forIndexPath:indexPath];
            
            [self configShopNameButton:newProductCell.shopName width:recommend];
            
            newProductCell.productName.text     = recommend.name;
            newProductCell.productBrand.text    = recommend.brand;
            newProductCell.price1.price          = recommend.price1;
            newProductCell.price2.price          = recommend.price2;
            newProductCell.address.text         = [NSString stringWithFormat:@"%@-%@", recommend.region ,recommend.city];
            [newProductCell.productImageView sd_setImageWithURL:[NSURL URLWithString:recommend.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
            
            newProductCell.likeButton.item = recommend;
            [newProductCell.likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self updateLikeButton:newProductCell.likeButton item:recommend];
            
            cell = newProductCell;
            break;
        }
        case 4:
        {
            HomeShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:kShopIdentifier forIndexPath:indexPath];
            
            [self configShopNameButton:shopCell.shopName width:recommend];
            // fuck , 店面竟然在不同字段。
            [shopCell.shopName setTitle:recommend.name forState:UIControlStateNormal];
            // fuck
            
            shopCell.address.text   = [NSString stringWithFormat:@"%@-%@", recommend.region ,recommend.city];
            [shopCell.logoImage sd_setImageWithURL:[NSURL URLWithString:recommend.logoUrl] placeholderImage:[UIImage imageNamed:@""]];
            [shopCell.shopImage sd_setImageWithURL:[NSURL URLWithString:recommend.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
            
            shopCell.likeButton.item = recommend;
            [shopCell.likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self updateLikeButton:shopCell.likeButton item:recommend];
            
            cell = shopCell;
            
            break;
        }
        default:
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"错误错误!!!!";
            break;
        }
    }
    
    
    return cell;
}


- (void)configShopNameButton:(UIShopNameButton *)shopName width:(HomeRecommend *)recommend
{
    [shopName setTitle:recommend.shopName forState:UIControlStateNormal];
    [shopName addTarget:self action:@selector(shopNameClick:) forControlEvents:UIControlEventTouchUpInside];
    shopName.shopID = recommend.shopID;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    HomeRecommend * recommend = self.dataSource[indexPath.row];

    if ([recommend.type integerValue] == 4) {
        [self goShopViewControllerWithId:recommend.shopID];
    }else{
         NSString *url = recommend.detail_url;
        
        WebViewController *controller = [[WebViewController alloc] initWithURLString:url];
        controller.liked = [recommend.favorite boolValue];
        controller.type = [recommend.type integerValue];

        switch ([recommend.type integerValue]) {
            case 1: {
                controller.itemID = recommend.eventID;
            }
                break;
            case 2:{
                controller.itemID = recommend.guideID;
                break;
            }
            case 3:{
                controller.itemID = recommend.targetID;
                break;
            }
            case 4:{
                controller.itemID = recommend.shopID;
                break;
            }
        }

        SSLog(@"HomeViewController-%@",controller.itemID);

        [self pushViewControllerInNavgation:controller animated:YES];
    }
}

- (void)shopNameClick:(UIShopNameButton *)button
{
    [self goShopViewControllerWithId:button.shopID];
}

- (void)likeAction:(LikeButton *)sender
{
    ItemBaseInfo* item = (ItemBaseInfo*)sender.item;
    
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    
    if (!userInfo.isLogin) {
        [self showLoginViewController];
        return;
    }
    
    [HomeDataManager likeWithItem:item result:^(id data, NSError *error) {
        if (data) {
            //            item.favorite = @(![item.favorite boolValue]);
            [self updateLikeButton:sender item:item];
        }
    }];
    
}

- (void)updateLikeButton:(UIButton *)button item:(ItemBaseInfo*)item
{
    BOOL isLike = [item.favorite boolValue];
    UIImage *image = nil;
    UIImage *bgImage = nil;
    
    switch ([item.type integerValue]) {
        case 2:
            if (!isLike) {
                image = [UIImage imageNamed:@"common_like_40pt"];
            }else{
                image = [UIImage imageNamed:@"common_liked_40pt"];
            }
            break;
        case 3:
            if (!isLike) {
                image = [UIImage imageNamed:@"common_like_40pt"];
            }else{
                image = [UIImage imageNamed:@"common_liked_40pt"];
            }
            bgImage = [UIImage imageWithColor:SS_RGBAColor(127,127,127,0.5)];
            break;
        case 4:
            if (!isLike) {
                image = [UIImage imageNamed:@"common_like"];
            }else{
                image = [UIImage imageNamed:@"common_liked"];
            }
            break;
            
        default:
            break;
    }
    
    [button setImage:image forState:UIControlStateNormal];
    if (bgImage) {
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    }

}


//- (void)showLoginViewController
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kLoginRegisterStoryboard bundle:nil];
//    LoginViewController *login = [storyboard instantiateInitialViewController];
//    [self presentViewController:login animated:YES completion:^{
//        // completion
//    }];
//}

@end
