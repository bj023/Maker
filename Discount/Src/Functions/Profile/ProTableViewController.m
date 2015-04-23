//
//  ProTableViewController.m
//  Discount
//
//  Created by bilsonzhou on 15/3/25.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ProTableViewController.h"
#import "ProDataManager.h"
#import "UITableViewController+PullRefresh.h"
#import "UITableViewController+PullRefresh.h"
#import "FavGood.h"
#import "FavGuid.h"
#import "FavShop.h"
#import "Coupon.h"
#import "ShopTableViewCell.h"
#import "GoodTableViewCell.h"
#import "GuidTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MsgTableViewCell.h"
#import "CouponTableViewCell.h"
#import "CouponDetailViewController.h"
#import "WebViewController.h"

static CGFloat const kFavCellHeight = 140.0f;
static CGFloat const kMsgCellHeight = 150.0f;
static CGFloat const kCouponCellHeight = 130.0f;

static NSString *const kShopCellIdentifier   = @"kShopCellIdentifier";
static NSString *const kNewGoodIdentifier    = @"kNewGoodIdentifier";
static NSString *const kGuidIdentifier       = @"kGuidIdentifier";

static NSString *const kMsgCellIdentifier = @"kMsgCellIdentifier";
static NSString *const kCouponCellIdentifier = @"kCouponCellIdentifier";

@interface ProTableViewController ()

@end

@implementation ProTableViewController

@synthesize dataSource;
@synthesize opType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopTableViewCell" bundle:nil] forCellReuseIdentifier:kShopCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:kNewGoodIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GuidTableViewCell" bundle:nil] forCellReuseIdentifier:kGuidIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgTableViewCell" bundle:nil] forCellReuseIdentifier:kMsgCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:kCouponCellIdentifier];
    
    [self getInitData];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    WEAKSELF(weakSelf)
    [self addPullToRefreshWithActionHandler:^{
        [weakSelf refreshAllData];
    }];
    
    [self addInfiniteScrollingWithActionHandler:^{
        [weakSelf moreData];
    }];
}


- (void)getInitData
{
    if (self.tableView.style == UITableViewStyleGrouped || self.opType != OpertationItemType_MsgList) {
        self.tableView.separatorColor = [UIColor clearColor];
    }
    
    self.dataSource = [NSMutableArray arrayWithArray:[ProDataManager itemInfoForType:opType From:0 op:OpertationType_PullToRefresh count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!self.dataSource.count && data) {
            self.dataSource = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
    
        if (!self.dataSource.count) {//拉取错误
             [self loadEmptyBackgroundWithTitle:@"还没有任何数据" image:[UIImage imageNamed:@"shop_home_empty"]];
        }
        
    }]] ;
    
    if (!self.dataSource.count) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else
    {
        [self.tableView reloadData];
    }

}
- (void)refreshAllData
{
    [ProDataManager itemInfoForType:opType From:0 op:OpertationType_PullToRefresh count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {
        if (data) {
            self.dataSource = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        [self stopPullAnimation];
    }];
}

- (void)moreData
{
    ItemBaseInfo *lastItem = self.dataSource.lastObject;

    [ProDataManager itemInfoForType:opType From:lastItem op:OpertationType_InfiniteScroll count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error){
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.opType == OpertationItemType_Coupon) {
        return self.dataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.opType == OpertationItemType_Coupon) {
        return 1;
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (opType) {
        case OpertationItemType_FavShop:
        case OpertationItemType_FavGood:
        case OpertationItemType_FavGuid:
            return kFavCellHeight;
        case OpertationItemType_Coupon:
            return kCouponCellHeight;
        case OpertationItemType_MsgList:
            return kMsgCellHeight;
        default:
            break;
    }
    return kFavCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.tableView.style == UITableViewStyleGrouped) {
        return 15.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.tableView.style == UITableViewStyleGrouped) {
        return 0.1f;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (opType) {
        case OpertationItemType_MsgList:
        {
            MsgTableViewCell *msgCell = [tableView dequeueReusableCellWithIdentifier:kMsgCellIdentifier forIndexPath:indexPath];
            
            MsgItemInfo *msgInfo = self.dataSource[indexPath.row];
            msgCell.titleLabel.text = msgInfo.title;
            if (msgInfo.content) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:msgInfo.content];
                [attributedString addAttributes:@{NSForegroundColorAttributeName:SS_HexRGBColor(0x999999)}
                                          range:NSMakeRange(0, msgInfo.content.length)];
                if (msgInfo.typeName) {
                    NSAttributedString *typeAttribute = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]", msgInfo.typeName]
                                                                                        attributes:@{NSForegroundColorAttributeName:MAIN_THEME_COLOR}];
                    [attributedString insertAttributedString:typeAttribute atIndex:0];
                }
                msgCell.contentLabel.attributedText = attributedString;
            }

            msgCell.locationLabel.text = [NSString stringWithFormat:@"%@ - %@",  msgInfo.region, msgInfo.city];
            msgCell.shopNameLabel.text = msgInfo.shopName;
            cell = msgCell;
        }
            break;
        case OpertationItemType_FavShop:
        {
            FavShop *favShop = self.dataSource[indexPath.row];
            ShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:kShopCellIdentifier forIndexPath:indexPath];
            shopCell.nameLable.text = favShop.name;
            shopCell.region.text = favShop.region;
//            shopCell.city.text = favShop.city;
            [shopCell.logImgView sd_setImageWithURL:[NSURL URLWithString:favShop.logoUrl] placeholderImage:[UIImage imageNamed:@""]];
            
            cell = shopCell;
        }
            break;
            
        case OpertationItemType_FavGood:
        {
            FavGood *favGood = self.dataSource[indexPath.row];
            GoodTableViewCell *goodCell = [tableView dequeueReusableCellWithIdentifier:kNewGoodIdentifier forIndexPath:indexPath];
            [goodCell.thumb sd_setImageWithURL:[NSURL URLWithString:favGood.thumb] placeholderImage:[UIImage imageNamed:@""]];
            goodCell.brand.text = favGood.brand;
            goodCell.name.text = favGood.name;
            goodCell.region.text = favGood.region;
            goodCell.city.text = favGood.city;
            goodCell.shopName.text = favGood.shopName;
            cell = goodCell;
        }
            
            break;
        case OpertationItemType_FavGuid:
        {
            FavGuid *favGuid = self.dataSource[indexPath.row];
            GuidTableViewCell *guidCell = [tableView dequeueReusableCellWithIdentifier:kGuidIdentifier forIndexPath:indexPath];
            [guidCell.thumb sd_setImageWithURL:[NSURL URLWithString:favGuid.thumb] placeholderImage:[UIImage imageNamed:@""]];
            guidCell.title.text = favGuid.title;
            guidCell.region.text = favGuid.region;
//            guidCell.city.text = favGuid.city;
            guidCell.shopName.text = favGuid.shopName;
            cell = guidCell;
        }
            break;
        case OpertationItemType_Coupon:
        {
            Coupon *coupon = self.dataSource[indexPath.section]; // coupon is grouped tableview, and hold multi sections
            CouponTableViewCell *couponCell = [tableView dequeueReusableCellWithIdentifier:kCouponCellIdentifier forIndexPath:indexPath];

            couponCell.codeLable.text = coupon.code;
            couponCell.shopName.text = coupon.shopName;
            couponCell.name.text = coupon.name;
            NSString *dateStr = [coupon.startDate stringByAppendingString:@"--"];
            dateStr = [dateStr stringByAppendingString:coupon.endDate];
            couponCell.date.text = dateStr;
            [couponCell setBarOrQrCodeImg:coupon.code withType:coupon.type.integerValue];
            
            couponCell.used = [coupon.used boolValue];
            couponCell.expired = [coupon.expired boolValue];
            
            cell = couponCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (ShopType)shopTypeFromItem:(MsgItemInfo *)item {
    ShopType type = ShopTypeHome;
    NSString *typeName = item.typeName;
    if ([typeName isEqualToString:@"系统"]) {
        type = ShopTypeHome;
    }
    else if ([typeName isEqualToString:@"新品"]) {
        type = ShopTypeNewProduct;
    }
    else if ([typeName isEqualToString:@"独享惠"]) {
        type = ShopTypeBrand; // TODO(jacky):这个该跳转到何处？
    }
    else if ([typeName isEqualToString:@"活动"]) {
        type = ShopTypeDiscount;
    }
    
    return type;
}

- (void)goShopViewControllerWithUserInfo:(NSDictionary *)userInfo {
    UIViewController *controller = userInfo[@"controller"];
    NSIndexPath *indexPath = userInfo[@"indexPath"];
    MsgItemInfo *msgInfo = self.dataSource[indexPath.row];
    [controller goShopViewControllerWithId:msgInfo.shopID type:[self shopTypeFromItem:msgInfo]];
}

- (void)showMessageDetail:(NSIndexPath *)indexPath {
    MsgItemInfo *msgInfo = self.dataSource[indexPath.row];
    
    if ([msgInfo.type intValue] == 1) {
        return;
    }
    
    WebViewController *controller = [[WebViewController alloc] initWithURLString:msgInfo.detail_url];
    // TODO(ff): 消息type和itemID
    SSLog(@"%@",msgInfo);
    
    switch ([msgInfo.type integerValue]) {
        case 2:
            controller.type = 3;
            break;
        case 3:
        case 4:
            controller.type = 1;
            break;
        default:
            break;
    }
    
    controller.itemID = msgInfo.targetID;
    SSLog(@"ProTableViewController-%@",controller.itemID);
    [self.parentViewController pushViewControllerInNavgation:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    switch (opType) {
        case OpertationItemType_Coupon:
        {
            Coupon *coupon = self.dataSource[indexPath.section];
            CouponDetailViewController *couponDetailviewCtr = [[CouponDetailViewController alloc] initWithCouponID:coupon.couponID];
            [self.parentViewController pushViewControllerInNavgation:couponDetailviewCtr animated:YES];
            
        }
            break;
            
        case OpertationItemType_MsgList: {
            [self showMessageDetail:indexPath];
        }
            break;
            
        default:
            break;
    }
    
}

@end
