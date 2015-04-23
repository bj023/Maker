//
//  ShopSearchViewController.m
//  Discount
//
//  Created by jackyzeng on 3/10/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopSearchViewController.h"
#import "ShopSearchViewCell.h"
#import "ShopSearchListViewController.h"
#import "ShopBrandViewController.h"
#import "ShopSearchBrandTypeCell.h"
#import "ShopBrandSearchController.h"
#import "ShopSearchResultsController.h"
#import "UISearchBar+Customize.h"
// Data
#import "ShopDataManager.h"
#import "ShopBrandCategoryInfo.h"
#import "ShopBrandCategory.h"
#import "ShopBrandLetterInfo.h"

static NSString *const kSearchCellIdentifier = @"SearchCellIdentifier";
static NSString *const kBrandTypeCellIdentifer = @"BrandTypeCellIdentifer";

@interface ShopSearchViewController () <UISearchBarDelegate, ShopSearchBrandTypeCellDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results

@property(nonatomic, strong) ShopBrandCategory *category;
@property(nonatomic, strong) NSMutableDictionary *searchIndexDict;
@property(nonatomic, strong) NSArray *builtIndextitles;
@property(nonatomic, strong) NSMutableArray *sectionIndextitles;

- (BOOL)hasCategory;

@end

@implementation ShopSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.searchIndexDict = [NSMutableDictionary dictionary];
    self.builtIndextitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    self.sectionIndextitles = [NSMutableArray array];
    
    self.tableView.sectionIndexColor = MAIN_THEME_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopSearchViewCell" bundle:nil] forCellReuseIdentifier:kSearchCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopSearchBrandTypeCell" bundle:nil] forCellReuseIdentifier:kBrandTypeCellIdentifer];
    
    self.category = [ShopDataManager shopBrandCategoryByShopID:self.shopID
                                                        result:^(id data, NSError *error) {
        if (!error && data) {
            self.category = data;
            
            [self.tableView reloadData];
        }
    }];
    
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.placeholder = searchBarHackingPlaceholder();
    [searchBar sizeToFit];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    [searchBar customizeSearchBarApperance];
}

- (void)insertLetter:(ShopBrandLetterInfo *)letter forKey:(NSString *)key {
    if (!key) {
        return;
    }
    
    NSUInteger keyIndex = [self.sectionIndextitles indexOfObject:key];
    if (keyIndex == NSNotFound) {
        [self.sectionIndextitles addObject:key];
    }
    
    NSMutableArray *indexArray = [self.searchIndexDict objectForKey:key];
    if (!indexArray) {
        indexArray = [NSMutableArray array];
    }
    [indexArray addObject:letter];
    [self.searchIndexDict setObject:indexArray forKey:key];
}

- (void)setCategory:(ShopBrandCategory *)category {
    _category = category;
    
    [self.searchIndexDict removeAllObjects];
    for (ShopBrandLetterInfo *letter in _category.letters) {
        BOOL matchIndex = NO;
        for (NSString *indexTitle in self.builtIndextitles) {
            if ([[letter.brandName uppercaseString] hasPrefix:indexTitle]) {
                [self insertLetter:letter forKey:indexTitle];
                matchIndex = YES;
                break;
            }
        }
        if (!matchIndex) {
            [self insertLetter:letter forKey:@"#"];
        }
    }
    
    // sort index titles
    [self.sectionIndextitles sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    // move "#" to the last
    if ([self.sectionIndextitles indexOfObject:@"#"] != NSNotFound) {
        [self.sectionIndextitles removeObject:@"#"];
        [self.sectionIndextitles addObject:@"#"];
    }
    
    _valueType = [self hasCategory] ? ShopSearchValueTypeKind : ShopSearchValueTypeAlphabet;
}

- (BOOL)hasCategory {
    return [_category.hasCategory boolValue];
}

- (void)setValueType:(ShopSearchValueType)valueType {
    _valueType = valueType;
    
    [self.tableView reloadData];
}

#pragma mark -  UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    ShopBrandSearchController *brandSearchController = [ShopBrandSearchController new];
    brandSearchController.shopID = self.shopID;

    brandSearchController.allProducts = [self.category.letters array];
    [self.parentViewController pushViewControllerInNavgation:brandSearchController animated:NO];
    return NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger extraSection = [self hasCategory] ? 1 : 0;
    
    if (self.valueType == ShopSearchValueTypeKind) {
        return extraSection + 1;
    }
    else {
        return extraSection + self.sectionIndextitles.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self hasCategory] && section == 0) {
        return 1;
    }

    if (self.valueType == ShopSearchValueTypeKind) {
        return self.category.categories.count;
    }
    else {
        NSInteger index = [self hasCategory] ? section - 1 : section;
        NSString *key = self.sectionIndextitles[index];
        return [self.searchIndexDict[key] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasCategory] && indexPath.section == 0) {
        return 39.0f;
    }
    
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasCategory] && indexPath.section == 0) {
        ShopSearchBrandTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kBrandTypeCellIdentifer forIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    ShopSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCellIdentifier forIndexPath:indexPath];
    if (self.valueType == ShopSearchValueTypeKind) {
        ShopBrandCategoryInfo *categoryInfo = self.category.categories[row];
        NSString *key = categoryInfo.categoryName;
        NSString *value = [categoryInfo.num stringValue];
        NSString *text = [NSString stringWithFormat:@"%@ %@", key, value];
        NSRange range = [text rangeOfString:value];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
        [attr addAttributes:@{NSForegroundColorAttributeName:SS_HexRGBColor(0x333333)} range:[text rangeOfString:text]];
        [attr addAttributes:@{NSForegroundColorAttributeName:SS_HexRGBColor(0x999999)} range:range];
        cell.nameLabel.attributedText = attr;
    }
    else {
        NSInteger index = [self hasCategory] ? section - 1 : section;
        NSString *key = self.sectionIndextitles[index];
        ShopBrandLetterInfo *letterInfo = self.searchIndexDict[key][row];
        cell.nameLabel.text = letterInfo.brandName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if ([self hasCategory] && indexPath.section == 0) {
        return;
    }
    if (self.valueType == ShopSearchValueTypeKind) {
        ShopBrandCategoryInfo *categoryInfo = self.category.categories[row];
        ShopSearchResultsController *resultController = [ShopSearchResultsController new];
        resultController.title = categoryInfo.categoryName;
        resultController.shopID = self.shopID;
        [resultController needRequestProductsFromShop:self.shopID inCategory:categoryInfo.categoryId];
        [self.parentViewController pushViewControllerInNavgation:resultController animated:YES];
    }
    else {
        ShopBrandViewController *brand = [ShopBrandViewController new];
        NSInteger index = [self hasCategory] ? section - 1 : section;
        NSString *key = self.sectionIndextitles[index];
        ShopBrandLetterInfo *letterInfo = self.searchIndexDict[key][row];
        brand.brandID = letterInfo.brandId;
        brand.shopID = self.shopID;
        [self.parentViewController pushViewControllerInNavgation:brand animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self hasCategory] && section == 0) {
        return nil;
    }
    
    if (self.valueType == ShopSearchValueTypeAlphabet) {
        
        UIView *headView = [[UIView alloc] init];
        NSInteger index = [self hasCategory] ? section - 1 : section;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 50, 20)];
        title.text = self.sectionIndextitles[index];
        [headView addSubview:title];
        
        return headView;
    }
    return nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if ([self hasCategory] && section == 0) {
//        return nil;
//    }
//    
//    if (self.valueType == ShopSearchValueTypeAlphabet) {
//        NSInteger index = [self hasCategory] ? section - 1 : section;
//        return self.sectionIndextitles[index];
//    }
//
//    return nil;
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.valueType == ShopSearchValueTypeKind) {
        return nil;
    }
    
    return self.sectionIndextitles;
}

#pragma mark - ShopSearchBrandTypeCellDelegate

- (void)brandTypeCell:(ShopSearchBrandTypeCell *)cell selectType:(ShopSearchValueType)type {
    self.valueType = type;
}

@end
