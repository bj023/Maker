//
//  ShopNewProductViewController.m
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopNewProductViewController.h"

#import "ShopNewProductMoreCell.h"
#import "ShopNewProductSingleCell.h"
#import "ShopNewProductStyleSwitch.h"
#import "ShopProductDetailViewController.h"
#import "ShopDataManager.h"
#import "WebViewController.h"

static CGFloat const kTableHeaderHeight = 49.0f;
static CGFloat const kSingleCellHeight = 480.0f;
static CGFloat const kMoreCellHeight = 315.0f;

static NSString *const kMoreCellIdentifier = @"MoreCellIdentifier";
static NSString *const kSingleCellIdentifier = @"SingleCellIdentifier";

@interface ShopNewProductViewController () <ShopNewProductItemDelegate>

@property(nonatomic, strong) NSMutableArray *products;

- (void)layoutTableHeaderView:(UIView *)headerView;
- (void)configProductInfo:(NSDictionary *)info to:(id<ShopNewProductInfo>)object;
- (void)selectItemAt:(NSInteger)index;

@end

@implementation ShopNewProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopNewProductSingleCell" bundle:nil] forCellReuseIdentifier:kSingleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopNewProductMoreCell" bundle:nil] forCellReuseIdentifier:kMoreCellIdentifier];
    
//    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"ShopNewProductStyleSwitch" owner:nil options:nil];
//    ShopNewProductStyleSwitch *styleSwitch = [viewArray objectAtIndex:0];
//    [styleSwitch addTarget:self action:@selector(onStyleChanged:) forControlEvents:UIControlEventValueChanged];
//    styleSwitch.currentStyle = ShopNewProductViewStyleSingle;
//    
//    [self layoutTableHeaderView:styleSwitch];
//    self.tableView.tableHeaderView = styleSwitch;
    
//    _productStyle = styleSwitch.currentStyle;
    
    
    
    _productStyle = ShopNewProductViewStyleMore;
    self.products = [NSMutableArray arrayWithArray:[ShopDataManager newProductItemFrom:nil shopID:self.shopID count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {

        if (data) {
            self.products = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        }
        
    }]];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WEAKSELF(weakSelf);
    [self addInfiniteScrollingWithActionHandler:^{
        [ShopDataManager newProductItemFrom:[weakSelf.products lastObject] shopID:weakSelf.shopID count:ONCE_PULL_ITEM_COUNT result:^(id data, NSError *error) {

            if (data) {
                if (weakSelf.products) {
                    [weakSelf.products addObjectsFromArray:data];
                }else{
                    weakSelf.products = [NSMutableArray arrayWithArray:data];
                }
                [weakSelf.tableView reloadData];
                
            }
            [weakSelf stopInfiniteScrollingAnimation];
            
        }];
    }];
}


- (void)setProducts:(NSMutableArray *)products {
    _products = products;
    
    if (products.count > 0) {
        [self clearEmptyBackground];
    }
    else {
        [self loadEmptyBackgroundWithTitle:@"还没有新品数据" image:[UIImage imageNamed:@"shop_newproduct_empty"]];
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

- (void)setProductStyle:(ShopNewProductViewStyle)productStyle {
    _productStyle = productStyle;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.productStyle == ShopNewProductViewStyleSingle) {
        return self.products.count;
    }
    else {
        return self.products.count / 2 + self.products.count % 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.productStyle == ShopNewProductViewStyleSingle ? kSingleCellHeight : kMoreCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  nil;
    NSInteger row = indexPath.row;
    
    if (self.productStyle == ShopNewProductViewStyleSingle) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSingleCellIdentifier forIndexPath:indexPath];
        ShopNewProductSingleCell *singleCell = (ShopNewProductSingleCell *)cell;
        [self configProductInfo:self.products[row] to:singleCell];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kMoreCellIdentifier forIndexPath:indexPath];
        ShopNewProductMoreCell *moreCell = (ShopNewProductMoreCell *)cell;
        moreCell.item0.hidden = NO;
        moreCell.item1.hidden = 2 * row + 1 >= self.products.count;
        moreCell.item0.delegate = self;
        moreCell.item1.delegate = self;
        
        [self configProductInfo:self.products[2 * row] to:moreCell.item0];
        if (!moreCell.item1.hidden) {
            [self configProductInfo:self.products[2 * row + 1] to:moreCell.item1];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.productStyle == ShopNewProductViewStyleSingle) {
        [self selectItemAt:indexPath.row];
    }
    else {
        // Do select actions in |itemSelected:|
    }
}

#pragma mark -

- (void)configProductInfo:(ShopNewProduct *)info to:(id<ShopNewProductInfo>)object {
    if (info == nil || object == nil) {
        return;
    }
    object.item = info;
    object.vc = self;
    
    object.nameLabel.text = info.brand;
    object.contentLabel.text = info.name;
    object.liked = [info.favorite boolValue];
    [object.productImageView sd_setImageWithURL:[NSURL URLWithString:info.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    
    NSString *price = [NSString stringWithFormat:@"%@ %@", info.price1, info.price2];

    if ([object isKindOfClass:[ShopNewProductItem class]]) {
        price = [price stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    }
    object.priceLabel.price = price;
}

- (void)onStyleChanged:(id)sender {
    ShopNewProductStyleSwitch *styleSwitch = (ShopNewProductStyleSwitch *)sender;
    self.productStyle = styleSwitch.currentStyle;
}

- (void)selectItemAt:(NSInteger)index {
    if (index < 0 || index >= self.products.count) {
        return;
    }
    
    // 商店的新品
    ShopNewProduct *newProduct = self.products[index];
    WebViewController *controller = [[WebViewController alloc] initWithURLString:newProduct.detail_url];
    controller.type     = [newProduct.type integerValue];
    controller.liked    = [newProduct.favorite boolValue];
    controller.itemID   = newProduct.targetID;

    SSLog(@"ShopNewProductViewcontroller-%@",controller.itemID);

    
    [self.parentViewController pushViewControllerInNavgation:controller animated:YES];
}

#pragma mark - ShopNewProductItemDelegate

- (void)itemSelected:(ShopNewProductItem *)item {
    if (self.productStyle != ShopNewProductViewStyleMore) {
        return;
    }
    
    // we can only select visible cells.
    NSArray *visibleCells = [self.tableView visibleCells];
    NSInteger itemIndex = -1;
    for (ShopNewProductMoreCell *cell in visibleCells) {
        if (cell.item0 == item) {
            itemIndex = 0;
        }
        else if (cell.item1 == item) {
            itemIndex = 1;
        }
        if (itemIndex >= 0) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self selectItemAt:itemIndex + 2 * indexPath.row];
            break;
        }
    }
}

@end
