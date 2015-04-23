//
//  ShopProductDetailViewController.m
//  Discount
//
//  Created by MacQB on 3/15/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopProductDetailViewController.h"
#import "LikeShareControl.h"
#import "ShopProductBriefCell.h"
#import "ShopProductCommonCell.h"
#import "ShopProductDescriptionCell.h"
#import "NewProductDetail.h"
#import "ShopDataManager.h"

static CGFloat const kTableViewHeaderHeight = 405.0f;

static NSString *const kBriefCellIdentifier = @"BriefCellIdentifier";
static NSString *const kCommonCellIdentifier = @"CommonCellIdentifier";
static NSString *const kDescriptionCellIdentifier = @"DescriptionCellIdentifier";

@interface ShopProductDetailViewController ()

@property(nonatomic, strong) UIButton *backButton;

@property(nonatomic, strong) NewProductDetail *productDetail;

@end

@implementation ShopProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    LikeShareControl *control = [[LikeShareControl alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    control.itemID = self.productDetail.shopID;
    control.vc = self;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:control];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[space1, item, space2];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopProductBriefCell" bundle:nil] forCellReuseIdentifier:kBriefCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopProductCommonCell" bundle:nil] forCellReuseIdentifier:kCommonCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopProductDescriptionCell" bundle:nil] forCellReuseIdentifier:kDescriptionCellIdentifier];
    
    self.productDetail = [ShopDataManager newProductDetailInfoByShopID:self.shopID goodID:self.goodsID result:^(id data, NSError *error) {
        if (!error && data) {
            self.productDetail = data;
            [self.tableView reloadData];
            
            UIImageView *headerImageView = (UIImageView *)self.tableView.tableHeaderView;
            [headerImageView sd_setImageWithURL:[NSURL URLWithString:((NewProductImages *)self.productDetail.images[0]).imageUrl]];
            
        }
    }];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, kTableViewHeaderHeight)];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:((NewProductImages *)self.productDetail.images[0]).imageUrl]];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
    self.tableView.tableHeaderView = headerImageView;
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.backButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [self.backButton setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setAlpha:0.0];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.4f animations:^{
        [self.backButton setAlpha:1.0];
    }];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.backButton removeFromSuperview];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

//- (void)setPrice:(NSString *)price {
//    _price = price;
//    
//    [self.tableView reloadData];
//}

- (void)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 55.0f;
    }
    
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case 0: {
            ShopProductBriefCell *bCell = [tableView dequeueReusableCellWithIdentifier:kBriefCellIdentifier forIndexPath:indexPath];
            if (self.productDetail.price1) {
                bCell.priceLabel.price = [NSString stringWithFormat:@"%@\n%@", self.productDetail.price1, self.productDetail.price2];
//                bCell.priceLabel.price = self.productDetail.price1;
            }
            bCell.brandLabel.text   = self.productDetail.brand;
            bCell.nameLabel.text    = self.productDetail.name;
            cell = bCell;
        }
            break;
            
        case 1: {
            ShopProductCommonCell *cCell = [tableView dequeueReusableCellWithIdentifier:kCommonCellIdentifier forIndexPath:indexPath];
            
            cCell.itemLabel.text = self.productDetail.artNo;
            cCell.colorLabel.text = self.productDetail.color;
            
            cell = cCell;
        }
            break;
            
        case 2: {
            ShopProductDescriptionCell *dCell = [tableView dequeueReusableCellWithIdentifier:kDescriptionCellIdentifier forIndexPath:indexPath];
            dCell.contentLabel.text = self.productDetail.intro;
            cell = dCell;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
