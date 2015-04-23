//
//  ShopRebateViewController.m
//  Discount
//
//  Created by jackyzeng on 3/8/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopRebateViewController.h"

#import "ShopRebateTableHeaderView.h"
#import "ShopRebateContentCell.h"
#import "ShopViewController.h"
#import "ShopDataManager.h"

static CGFloat const kTableHeaderHeight = 310.f;
static CGFloat const kCellTitleHeaderHeight = 48.0f;
static CGFloat const kCellContentTopPadding  = 15.0f;
static CGFloat const kCellContentBottomPadding  = 15.0f;

static NSString *const kShopRebateContentCellIdentifier = @"ShopRebateContentCellIdentifier";

@interface ShopRebateViewController ()

@property(nonatomic, strong) ShopRebateContentCell *contentPropertyCell;
@property(nonatomic, strong) ShopTaxRefund *refund;

- (void)layoutTableHeaderView:(UIView *)headerView;

@end

@implementation ShopRebateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopRebateContentCell" bundle:nil] forCellReuseIdentifier:kShopRebateContentCellIdentifier];
    
    NSArray *headerArray = [[NSBundle mainBundle] loadNibNamed:@"ShopRebateTableHeaderView" owner:nil options:nil];
    ShopRebateTableHeaderView *headerView = [headerArray objectAtIndex:0];
    
    [self layoutTableHeaderView:headerView];
    self.tableView.tableHeaderView = headerView;
    
    self.refund = [ShopDataManager taxRefundByShopID:self.shopID result:^(id data, NSError *error) {
        if (!error && data) {
            self.refund = data;
            [self.tableView reloadData];
        }
    }];
    
    self.contentPropertyCell = [self.tableView dequeueReusableCellWithIdentifier:kShopRebateContentCellIdentifier];
}

- (void)setRefund:(ShopTaxRefund *)refund {
    _refund = refund;
    
    ShopRebateTableHeaderView *headerView = (ShopRebateTableHeaderView *)self.tableView.tableHeaderView;
    [headerView.imageView sd_setImageWithURL:[NSURL URLWithString:_refund.img]
                            placeholderImage:[UIImage imageNamed:@""]];
    
    headerView.searchButton.hidden = !(_refund.coordsArray && [_refund.coordsArray count] > 0);
    
    
    [headerView.searchButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doSearch:(id)sender
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    if ([viewControllers count] >= 2) {
        UIViewController *controller = viewControllers[1];
        [self.navigationController popToViewController:controller animated:YES];
        if ([controller isKindOfClass:[ShopViewController class]]) {

            
            ShopViewSwitcher *switcher = [(ShopViewController *)controller switcher];
            // TODO(jacky):replace the magic number 5.
            switcher.serviceID = self.refund.serviceId;
            switcher.floor = [self.refund.locationDict objectForKey:@"floor"];

            NSInteger index = 0;
            for (NSString *title in switcher.titles) {
                
                if ([title isEqualToString:@"地图"]) {
                    break;
                }
                index ++;
            }
            
            switcher.shopType = ShopRebateType;
            [switcher selectIndex:index];
            [switcher sendValueChangedEvent];
        }
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)layoutTableHeaderView:(UIView *)headerView {
    CGRect headerFrame =  headerView.frame;
    headerFrame.size.height = kTableHeaderHeight;
    headerView.frame = headerFrame;
}

- (void)viewWillLayoutSubviews {
    [self layoutTableHeaderView:self.tableView.tableHeaderView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopRebateContentCell *cell = self.contentPropertyCell;
    
    NSString *str = indexPath.row == 0 ? self.refund.fillFormIntro : self.refund.sealIntro;
    cell.contentLabel.text = str;
    CGSize s = [str calculateSize:CGSizeMake(self.tableView.frame.size.width - 50, FLT_MAX) font:cell.contentLabel.font];
    CGFloat defaultHeight = cell.contentView.frame.size.height;
    CGFloat offset = kCellTitleHeaderHeight + kCellContentTopPadding + kCellContentBottomPadding;
    CGFloat height = s.height + offset > defaultHeight ? s.height + offset : defaultHeight;
    return 1 + height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopRebateContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopRebateContentCellIdentifier forIndexPath:indexPath];
    NSString *title = indexPath.row == 0 ? @"填表" : @"盖章";
    NSString *content = indexPath.row == 0 ? self.refund.fillFormIntro : self.refund.sealIntro;
    
    cell.nameLabel.text = title;
    cell.contentLabel.text = content;
    
    return cell;
}

@end
