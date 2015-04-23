//
//  CouponDetailTableViewCotnroller.m
//  Discount
//
//  Created by jackyzeng on 4/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "CouponDetailTableViewCotnroller.h"
#import "CouponDetail.h"
#import "CouponDetailShopNameCell.h"
#import "CouponContentCell.h"

static CGFloat const kShopNameCellHeight = 85.0f;
static CGFloat const kCellContentTopPadding  = 20.0f;
static CGFloat const kCellContentBottomPadding  = 30.0f;

static NSString *const kCouponDetailShopNameCellIdentifier = @"CouponDetailShopNameCellIdentifier";
static NSString *const kCouponDetailContentCellIdentifier = @"CouponDetailContentCellIdentifier";

@interface CouponDetailTableViewCotnroller ()

@property(nonatomic, strong) CouponContentCell *contentPropertyCell;

@property(nonatomic, strong) NSMutableArray *contents;
@property(nonatomic, strong) NSString *logoURL;

@end

@implementation CouponDetailTableViewCotnroller

- (NSMutableArray *)contents {
    if (_contents == nil) {
        _contents = [NSMutableArray array];
    }
    
    return _contents;
}

- (void)setCouponDetail:(CouponDetail *)couponDetail {
    [self.contents removeAllObjects];
    
    [self.contents addObject:NoNullString(couponDetail.shopName)];
    [self.contents addObject:NoNullString(couponDetail.nameCn)];
    [self.contents addObject:NoNullString(couponDetail.detailCn)];
    [self.contents addObject:NoNullString(couponDetail.attentionCn)];
    
    self.logoURL = couponDetail.shopLogo;
    
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponDetailShopNameCell" bundle:nil]
         forCellReuseIdentifier:kCouponDetailShopNameCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponContentCell" bundle:nil]
         forCellReuseIdentifier:kCouponDetailContentCellIdentifier];
    
    self.contentPropertyCell = [self.tableView dequeueReusableCellWithIdentifier:kCouponDetailContentCellIdentifier];
    [self.tableView reloadData];
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
    return self.contents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kShopNameCellHeight;
    }
    
    CouponContentCell *cell = self.contentPropertyCell;
    
    NSString *str = self.contents[indexPath.row];
    cell.contentLabel.text = str;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    if (indexPath.row == 1) {
        font = [UIFont systemFontOfSize:20.0f];
    }
    CGSize s = [str calculateSize:CGSizeMake(self.tableView.frame.size.width, FLT_MAX) font:font];
    CGFloat defaultHeight = cell.contentView.frame.size.height;
    CGFloat offset = kCellContentTopPadding + kCellContentBottomPadding;
    CGFloat height = s.height + offset > defaultHeight ? s.height + offset : defaultHeight;
    return 1 + height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *retCell = nil;
    if (indexPath.row == 0) {
        CouponDetailShopNameCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponDetailShopNameCellIdentifier forIndexPath:indexPath];
        
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.logoURL]];
        cell.nameLabel.text = self.contents[0];

        return cell;

    }
    else {
        CouponContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponDetailContentCellIdentifier forIndexPath:indexPath];
        cell.contentLabel.text = self.contents[indexPath.row];
        if (indexPath.row == 2 || indexPath.row == 3) {
            cell.contentLabel.font = [UIFont systemFontOfSize:15.0f];
            cell.contentLabel.textColor = SS_HexRGBColor(0xcccccc);
        }
        else {
            cell.contentLabel.font = [UIFont systemFontOfSize:20.0f];
            cell.contentLabel.textColor = SS_HexRGBColor(0x333333);
        }

        return cell;
    }

    return retCell;
}

@end
