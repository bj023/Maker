//
//  ShopBrandViewController.m
//  Discount
//
//  Created by jackyzeng on 3/10/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopBrandViewController.h"
#import "ShopBrandIntroCell.h"
#import "ShopViewController.h"
#import "ShopDataManager.h"

static CGFloat const kImageCellHeight = 190.0f;
static CGFloat const kLogoCellHeight = 70.0f;
static CGFloat const kToolbarHeight = 54.0f;

static NSInteger const kImageViewTag = 100;
static NSInteger const kLogoViewTag = 101;

static NSString *const kImageCellIdentifier = @"ImageCellIdentifier";
static NSString *const kLogoCellIdentifier = @"LogoCellIdentifier";
static NSString *const kIntroCellIdentifier = @"introCellIdentifier";

@interface ShopBrandViewController ()

@property(nonatomic, strong) ShopBrandIntroCell *introPropertyCell;
@property(nonatomic, strong) UIToolbar *brandToolbar;
@property(nonatomic, strong) BrandDetail *brandDetail;

- (void)setupToolbar;

@end

@implementation ShopBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kImageCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLogoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopBrandIntroCell" bundle:nil] forCellReuseIdentifier:kIntroCellIdentifier];
    
    self.introPropertyCell = [self.tableView dequeueReusableCellWithIdentifier:kIntroCellIdentifier];
    
    
    self.brandDetail = [ShopDataManager brandDetailByShopID:self.shopID brandID:self.brandID result:^(id data, NSError *error) {
        if (!error && data) {
            self.brandDetail = data;

            [self.tableView reloadData];
        }
        
    }];
}

- (void)setBrandDetail:(BrandDetail *)brandDetail {
    _brandDetail = brandDetail;
    
    if ([_brandDetail.coordsArray count] == 0) {
        if (self.brandToolbar) {
            self.brandToolbar.hidden = YES;
            self.tableView.contentInset = UIEdgeInsetsZero;
        }
    }
    else {
        if (self.brandToolbar == nil) {
            [self setupToolbar];
        }
        self.brandToolbar.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.brandDetail.coordsArray count] > 0) {
        [self setupToolbar];
        CGRect toolbarFrame = self.brandToolbar.frame;
        toolbarFrame.origin.x += toolbarFrame.size.width;
        [self.brandToolbar setFrame:toolbarFrame];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect originFrame = toolbarFrame;
            originFrame.origin.x = 0;
            [self.brandToolbar setFrame:originFrame];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.brandToolbar) {
        [self.brandToolbar removeFromSuperview];
    }
}

- (void)setupToolbar {
    if (self.brandToolbar == nil) {
        self.brandToolbar = [[UIToolbar alloc] init];
        [self.brandToolbar sizeToFit];
        CGFloat toolbarHeight = kToolbarHeight;
        CGRect rootViewBounds = self.parentViewController.view.bounds;
        CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
        CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
        CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
        [self.brandToolbar setFrame:rectArea];
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, toolbarHeight, 0);
        [self.navigationController.view addSubview:self.brandToolbar];
        
        UIButton *searchButton = [[UIButton alloc] initWithFrame:self.brandToolbar.bounds];
        [searchButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
        [searchButton setImage:[UIImage imageNamed:@"common_location"] forState:UIControlStateNormal];
        [searchButton setTitle:@"位置查找" forState:UIControlStateNormal];
        [searchButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
        [searchButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
        UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolbarItems = @[space1, item, space2];
        [self.brandToolbar setItems:@[space1, item, space2]];
    }
}

- (void)doSearch:(id)sender {
    
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    if ([viewControllers count] >= 2) {
        UIViewController *controller = viewControllers[1];
        [self.navigationController popToViewController:controller animated:YES];
        if ([controller isKindOfClass:[ShopViewController class]]) {
            
            
            ShopViewSwitcher *switcher = [(ShopViewController *)controller switcher];
            // TODO(jacky):replace the magic number 5.
            switcher.brandID = self.brandDetail.brandID;
            switcher.floor = self.brandDetail.floor;
            
            
            NSInteger index = 0;
            for (NSString *title in switcher.titles) {
                
                if ([title isEqualToString:@"地图"]) {
                    break;
                }
                index ++;
            }
            
            switcher.shopType = ShopBrandType;
            [switcher selectIndex:index];
            [switcher sendValueChangedEvent];
        }
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return kImageCellHeight;
    }
    else if (row == 1) {
        return kLogoCellHeight;
    }
    else {
        ShopBrandIntroCell *cell = self.introPropertyCell;
        NSString *str = self.brandDetail.intro;
        cell.contentLabel.text = str;
        CGSize s = [str calculateSize:CGSizeMake(self.tableView.frame.size.width - 30.0f, FLT_MAX) font:cell.contentLabel.font];
        CGFloat defaultHeight = cell.contentView.frame.size.height;
        CGFloat offset = 60.0f;
        CGFloat height = s.height + offset > defaultHeight ? s.height + offset : defaultHeight;
        return 1 + height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifier forIndexPath:indexPath];
        [self configureImageViewWithFrame:cell.contentView.bounds
                              contentMode:UIViewContentModeScaleAspectFill
                                      tag:kImageViewTag
                                    imageUrl:self.brandDetail.imgUrl
                                  forCell:cell];
    }
    else if (row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:kLogoCellIdentifier forIndexPath:indexPath];
        CGRect logoFrame = CGRectMake(0, 0, 130, 60);
        [self configureImageViewWithFrame:logoFrame
                              contentMode:UIViewContentModeScaleAspectFit
                                      tag:kLogoViewTag
                                    imageUrl:self.brandDetail.logoUrl
                                  forCell:cell];
    }
    else {
        ShopBrandIntroCell *introCell = [tableView dequeueReusableCellWithIdentifier:kIntroCellIdentifier forIndexPath:indexPath];
        introCell.contentLabel.text = self.brandDetail.intro;
        cell = introCell;
    }
    
    return cell;
}

#pragma mark - 

- (void)configureImageViewWithFrame:(CGRect)frame
                        contentMode:(UIViewContentMode)mode
                                tag:(NSInteger)tag
                           imageUrl:(NSString *)imgUrl
                            forCell:(UITableViewCell *)cell {
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:tag];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.center = cell.contentView.center;
        imageView.contentMode = mode;
        imageView.clipsToBounds = YES;
        imageView.tag = tag;
        [cell.contentView addSubview:imageView];
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

@end
