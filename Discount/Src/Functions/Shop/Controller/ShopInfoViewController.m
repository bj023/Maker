//
//  ShopInfoViewController.m
//  Discount
//
//  Created by jackyzeng on 3/7/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "ShopInfoContentCell.h"
#import "ShopInfoCardCell.h"
#import "ShopInfoMapCell.h"
#import "ShopInfoTableHeaderView.h"
#import "ShopInfoTableFooterView.h"
#import "ShopDetail.h"
#import "ShopDataManager.h"
#import "ShopInfoMapViewController.h"

//static CGFloat const kTableHeaderHeight = 335.0f;
//static CGFloat const kTableFooterHeight = 150.0f;
static CGFloat const kCellTitleHeaderHeight = 48.0f;
static CGFloat const kCellContentTopPadding  = 15.0f;
static CGFloat const kCellContentBottomPadding  = 15.0f;

static CGFloat const kMapHeight = 250.0f;
//static CGSize const kCardSize  = {28.0f, 19.0f};

// 高德静态地图
static NSString *const kAMapRestKey = @"c95a0fe5bf76bc987ff94acf9d96722e";

static NSString *const kShopInfoContentCellIdentifier   = @"ShopInfoContentCellIdentifier";
static NSString *const kShopInfoCardCellIdentifier      = @"ShopInfoCardCellIdentifier";
static NSString *const kShopInfoMapCellIdentifier       = @"ShopInfoMapCellIdentifier";
static NSString *const kShopInfoHeaderIdentifier        = @"ShopInfoHeaderIdentifier";

@interface CardImageView : UIImageView

@end

@implementation CardImageView


@end

@interface ShopInfoViewController ()

@property(nonatomic, strong) NSArray *headerImageTitles;
@property(nonatomic, strong) NSMutableArray *contents;
@property(nonatomic, strong) NSMutableArray *contentsIndexes;
@property(nonatomic, strong) ShopInfoContentCell *contentPropertyCell;
@property(nonatomic, strong) ShopDetail *shopDetail;

@property(nonatomic, weak) ShopInfoTableHeaderView *headerView;

@end

@implementation ShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.headerImageTitles = @[@{@"image":@"info_shop",     @"title":@"简介"},
                               @{@"image":@"info_location", @"title":@"地址"},
                               @{@"image":@"info_bus",      @"title":@"交通方式"},
                               @{@"image":@"info_card",     @"title":@"付款方式"},
                               @{@"image":@"info_time",     @"title":@"营业时间"},
                               @{@"image":@"info_phone",    @"title":@"联系电话"},
                               @{@"image":@"info_link",     @"title":@"官网"},
                               @{@"image":@"info_other",    @"title":@"其他"},];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopInfoContentCell" bundle:nil] forCellReuseIdentifier:kShopInfoContentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopInfoContentCell" bundle:nil] forCellReuseIdentifier:kShopInfoCardCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopInfoMapCell" bundle:nil] forCellReuseIdentifier:kShopInfoMapCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headerView = (ShopInfoTableHeaderView *)self.tableView.tableHeaderView;
    
    self.contentPropertyCell = [self.tableView dequeueReusableCellWithIdentifier:kShopInfoContentCellIdentifier];
    self.shopDetail = [ShopDataManager shopDetailByID:self.shopID result:^(id data, NSError *error) {

        if (!error && data) {
            self.shopDetail = data;
            [self setContentArr];
            [self.tableView reloadData];
        }
        
    }];
    
    [self setContentArr];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return kCellTitleHeaderHeight + kMapHeight;
    }
    // 支付方式UI更新，改为纯文本
//    else if (indexPath.section == 3) {
//        return kCardSize.height + kCellTitleHeaderHeight + kCellContentTopPadding + kCellContentBottomPadding;
//    }
    
    ShopInfoContentCell *cell = self.contentPropertyCell;
    
    NSString *str = self.contents[indexPath.section];
    cell.contentLabel.text = str;
    CGSize s = [str calculateSize:CGSizeMake(self.tableView.frame.size.width - 50, FLT_MAX) font:cell.contentLabel.font];
    CGFloat defaultHeight = cell.contentView.frame.size.height;
    CGFloat offset = kCellTitleHeaderHeight + kCellContentTopPadding + kCellContentBottomPadding;
    CGFloat height = s.height + offset > defaultHeight ? s.height + offset : defaultHeight;
    return 1 + height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopInfoContentCell *cell = nil;
    NSInteger section = indexPath.section;
    
    NSString *identifier = kShopInfoContentCellIdentifier;
    if (section == 1) {
        identifier = kShopInfoMapCellIdentifier;
    }
    else if (section == 3) {
        identifier = kShopInfoCardCellIdentifier;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    NSInteger index = [self.contentsIndexes[section] integerValue];
    cell.logoImageView.image = [UIImage imageNamed:self.headerImageTitles[index][@"image"]];
    cell.nameLabel.text = self.headerImageTitles[index][@"title"];
    cell.contentLabel.text = self.contents[indexPath.section];
    
    // Do not need reuse the following cells
    // location
    if (section == 1) {
        ShopInfoMapCell *mapCell = (ShopInfoMapCell *)cell;

        
        NSString *mapUrl = @"http://restapi.amap.com/v3/staticmap?location=";
        
        mapUrl = [NSString stringWithFormat:@"%@%@&scale=1",mapUrl,self.shopDetail.coords];
        
        mapUrl = [NSString stringWithFormat:@"%@&zoom=8&size=%ld*%ld",mapUrl,(long)mapCell.frame.size.width,(long)mapCell.frame.size.height];
        
        mapUrl = [NSString stringWithFormat:@"%@&markers=mid,,A:%@",mapUrl,self.shopDetail.coords];
        
        mapUrl = [NSString stringWithFormat:@"%@&key=%@",mapUrl,kAMapRestKey];
        
        SSLog(@"%@",mapUrl);
        
        [mapCell.map sd_setImageWithURL:[NSURL URLWithString:mapUrl]];
        mapCell.locationLabel.text = self.shopDetail.addr;

    }
    
    // card
    // 支付方式UI更新，改为纯文本
    //    if (section == 3) {
    //        NSArray *cardArrar = @[@"card_amex", @"card_discover", @"card_visa", @"card_mc"];
    //        CGFloat x = 25, y = kCellTitleHeaderHeight + kCellContentTopPadding, w = kCardSize.width, h = kCardSize.height;
    //
    //        BOOL needsAddCardViews = YES;
    //        for (UIView *subview in cell.contentView.subviews) {
    //            if ([subview isKindOfClass:[CardImageView class]]) {
    //                needsAddCardViews = NO;
    //                break;
    //            }
    //        }
    //        if (needsAddCardViews) {
    //            for (NSInteger i = 0; i < cardArrar.count; i++) {
    //                CardImageView *card = [[CardImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    //                card.image = [UIImage imageNamed:cardArrar[i]];
    //                [cell.contentView addSubview:card];
    //
    //                x += w + 5;
    //            }
    //        }
    //
    //    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1) { // 地图详情
        NSString *coordsString = self.shopDetail.coords;
        NSArray *components = [coordsString componentsSeparatedByString:@","];
        CLLocationCoordinate2D coordinate;
        if ([components count] >= 1) {
            coordinate.latitude = [components[0] doubleValue];
        }
        if ([components count] >= 2) {
            coordinate.longitude  = [components[1] doubleValue];
        }
        ShopInfoMapViewController *mapController = [[ShopInfoMapViewController alloc] initWithCenterCoordinate:coordinate zoomLevel:6.0f];
        [self pushViewControllerInNavgation:mapController animated:YES];
    }
}

#pragma mark - private

- (void)addContent:(NSString *)content withIndex:(NSNumber *)index {
    if (content == nil || index == nil) {
        return;
    }
    
    // content is empty & not map
    if (content.length == 0 && ![index integerValue] != 1) {
        return;
    }
    [_contents addObject:content];
    [_contentsIndexes addObject:index];
}

- (void)setContentArr
{
    self.headerView.nameLabel.text = self.shopDetail.name;
    NSString *location = self.shopDetail.region;
    if (!location) {
        location = self.shopDetail.city;
    } else if (self.shopDetail.city) {
        location = [NSString stringWithFormat:@"%@ - %@", self.shopDetail.region, self.shopDetail.city];
    }
    self.headerView.locationLabel.text = location;
    [self.headerView.imageView sd_setImageWithURL:[NSURL URLWithString:self.shopDetail.imageUrl]
                                 placeholderImage:[UIImage imageNamed:@""]];
    
    if (!_contents) {
        _contents = [NSMutableArray array];
    }
    else {
        [_contents removeAllObjects];
    }
    if (!_contentsIndexes) {
        _contentsIndexes = [NSMutableArray array];
    }
    else {
        [_contentsIndexes removeAllObjects];
    }
    
    [self addContent:NoNullString(self.shopDetail.intro) withIndex:@(0)];
    [self addContent:@"" withIndex:@(1)];
    [self addContent:NoNullString(self.shopDetail.way) withIndex:@(2)];
    [self addContent:NoNullString(self.shopDetail.payment) withIndex:@(3)];
    [self addContent:NoNullString(self.shopDetail.shopHours) withIndex:@(4)];
    [self addContent:NoNullString(self.shopDetail.tel) withIndex:@(5)];
    [self addContent:NoNullString(self.shopDetail.website) withIndex:@(6)];
    [self addContent:NoNullString(self.shopDetail.others) withIndex:@(7)];
}

@end
