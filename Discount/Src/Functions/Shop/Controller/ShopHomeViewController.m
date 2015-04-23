//
//  ShopHomeViewController.m
//  Discount
//
//  Created by jackyzeng on 3/8/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopHomeViewController.h"

#import "ShareSheet.h"
#import "GoodsTableViewCell.h"
#import "ShopHomeHeaderCell.h"
#import "ShopInfoViewController.h"
#import "ShopDataManager.h"
#import "ShopRaidersCell.h"
#import "HomeNewProductTableViewCell.h"
#import "WebViewController.h"
#import "ShopProductDetailViewController.h"


static CGFloat const kShopRaidersCellHeight = 200.0f;
static CGFloat const kNewProductCellHeight  = 473.0f;
static CGFloat const kGoodsCellHeight = 260.0f;

static NSString *const kShopHomeHeaderCellIdentifier = @"ShopHomeHeaderCellIdentifier";
static NSString *const kGoodsCellIdentifier = @"GoodsCellIdentifier";
static NSString *const kShopRaidersCellIdentifier   = @"ShopRaidersCellIdentifier";
static NSString *const kNewProductIdentifier        = @"NewProductCellIdentifier";

@interface ShopHomeViewController ()

@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) ShopInfo *shopInfo;

@end

@implementation ShopHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopHomeHeaderCell" bundle:nil]
         forCellReuseIdentifier:kShopHomeHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsTableViewCell" bundle:nil]
         forCellReuseIdentifier:kGoodsCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopRaidersCell" bundle:nil] forCellReuseIdentifier:kShopRaidersCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeNewProductTableViewCell" bundle:nil] forCellReuseIdentifier:kNewProductIdentifier];
    
    self.dataSource = [NSMutableArray arrayWithArray:[ShopDataManager recommendItemFrom:nil shopID:self.shopID count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {

        if (!self.dataSource.count && data) {
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            self.dataSource = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        
    }]];
//
    self.shopInfo = [ShopDataManager shopInfoByShopID:self.shopID result:^(id data, NSError *error) {
        if (!error && data) {
            self.shopInfo = data;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setNavTitle" object:self.shopInfo.name];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:NO];
        }
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    WEAKSELF(weakSelf);
//    [self addInfiniteScrollingWithActionHandler:^{
//        [ShopDataManager recommendItemFrom:[weakSelf.dataSource lastObject] shopID:weakSelf.shopID count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
//            if (data) {
//                
//                if (weakSelf.dataSource) {
//                    [weakSelf.dataSource addObjectsFromArray:data];
//                }else{
//                    weakSelf.dataSource = [NSMutableArray arrayWithArray:data];
//                }
//                [weakSelf.tableView reloadData];
//                
//            }
//            [weakSelf stopInfiniteScrollingAnimation];
//            
//        }];
//    }];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    
    _dataSource = dataSource;
    
    if (_dataSource.count > 0) {
        [self clearEmptyBackground];
    }
    else {
        [self loadEmptyBackgroundWithTitle:@"还没有任何数据" image:[UIImage imageNamed:@"shop_home_empty"]];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 155.0f;
    }else{
        ShopHomeRecommend *recommend = self.dataSource[indexPath.row];
        switch ([recommend.type integerValue]) {
            case 1:
                return kGoodsCellHeight;
            case 2:
                return kShopRaidersCellHeight;
            case 3:
                return kNewProductCellHeight;
            default:
                return 44;
        }
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kShopHomeHeaderCellIdentifier forIndexPath:indexPath];
        
        ShopHomeHeaderCell *headerCell = (ShopHomeHeaderCell *)cell;
        [headerCell.infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.shopInfo.img] placeholderImage:[UIImage imageNamed:@""]];
        headerCell.nameLabel.text = self.shopInfo.name;
        headerCell.shopID = self.shopID;
        headerCell.vc = self;
        headerCell.liked = [self.shopInfo.favorite boolValue];

        headerCell.locationLabel.text = [NSString stringWithFormat:@"%@-%@",
                                         IsEmpty(self.shopInfo.region)?@"":self.shopInfo.region,
                                         IsEmpty(self.shopInfo.city)?@"":self.shopInfo.city];
        
    }else{
        ShopHomeRecommend *recommend = self.dataSource[indexPath.row];
        
        switch ([recommend.type integerValue]) {
            case 1:
            {
                GoodsTableViewCell *productCell = [tableView dequeueReusableCellWithIdentifier:kGoodsCellIdentifier forIndexPath:indexPath];
                
                [productCell.productImageView sd_setImageWithURL:[NSURL URLWithString:recommend.imageUrl]
                                            placeholderImage:[UIImage imageNamed:@""]];
                
                if (recommend.brand.length) {
                    productCell.contentLabel.text = recommend.title;
                    productCell.nameLabel.text   = recommend.brand;
                }else{
                    productCell.nameLabel.text = recommend.title;
                    productCell.contentLabel.text = nil;
                }
                
                productCell.discountImageView.image = [recommend.isDiscount integerValue] != 0 ? [UIImage imageNamed:@"home_cell_exclusive"] : nil;
                cell = productCell;
                break;
            }
                
            case 2:
            {
                ShopRaidersCell *raidersCell = [tableView dequeueReusableCellWithIdentifier:kShopRaidersCellIdentifier forIndexPath:indexPath];
                
                raidersCell.contentLabel.text = recommend.title;
                [raidersCell.raidersImageView sd_setImageWithURL:[NSURL URLWithString:recommend.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
                
                cell = raidersCell;
                break;
            }
            case 3:
            {
                HomeNewProductTableViewCell *newProductCell = [tableView dequeueReusableCellWithIdentifier:kNewProductIdentifier forIndexPath:indexPath];
                
                newProductCell.productName.text     = recommend.name;
                newProductCell.productBrand.text    = recommend.brand;
                newProductCell.price1.text          = recommend.price1; 
                newProductCell.price2.text          = recommend.price2;
                [newProductCell.productImageView sd_setImageWithURL:[NSURL URLWithString:recommend.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
                
                
                [newProductCell hidenButtonInfo];
                
                cell = newProductCell;
                break;
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        [self infoButtonPressed:self]; // show shop detail info
        return;
    }
    ShopHomeRecommend *recommend = self.dataSource[indexPath.row];
    WebViewController *controller = [[WebViewController alloc] initWithURLString:recommend.detail_url];
    controller.liked    = [recommend.favorite boolValue];
    controller.type     = [recommend.type integerValue];

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
    
    
    SSLog(@"ShopHomeViewController-%@",controller.itemID);


    [self.parentViewController pushViewControllerInNavgation:controller animated:YES];
}

- (void)infoButtonPressed:(id)sender {
    SSLog(@"/n/n<-infoButtonPressed->/n/n");
    ShopInfoViewController *viewVC =  [ShopInfoViewController new];
    viewVC.shopID = self.shopID;
    [self.parentViewController pushViewControllerInNavgation:viewVC animated:YES];
}

@end

