//
//  ShopBrandSearchController.m
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopBrandSearchController.h"
#import "ShopSearchResultsController.h"
#import "ShopSearchViewCell.h"
#import "ShopBrandViewController.h"
#import "UISearchBar+Customize.h"

// Data
#import "ShopBrandLetterInfo.h"

static NSString *const kSearchCellIdentifier = @"SearchCellIdentifier";

@interface ShopBrandSearchController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ShopSearchResultsController *resultsTableController;

@end

@implementation ShopBrandSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopSearchViewCell" bundle:nil] forCellReuseIdentifier:kSearchCellIdentifier];
    
    _resultsTableController = [[ShopSearchResultsController alloc] init];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder = searchBarHackingPlaceholder();
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar customizeSearchBarApperance];
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others

    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //self.searchController.active = YES;
    [self.searchController.searchBar becomeFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
}

#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented

}

- (void)didPresentSearchController:(UISearchController *)searchController {
    
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed

}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allProducts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    ShopSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = [self.allProducts[row] brandName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *allProducts = nil;
    if (tableView == self.tableView) {
        allProducts = self.allProducts;
    }
    else if (tableView == [(ShopSearchResultsController *)self.searchController.searchResultsController tableView]) {
        allProducts = [(ShopSearchResultsController *)self.searchController.searchResultsController allProducts];
    }
    
    if (allProducts == nil || allProducts.count == 0) {
        return;
    }
    
    ShopBrandViewController *brand = [ShopBrandViewController new];
    brand.brandID = [allProducts[indexPath.row] brandId];
    brand.shopID = self.shopID;
    [self pushViewControllerInNavgation:brand animated:YES];
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = self.searchController.searchBar.text;
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableArray *searchResults = [NSMutableArray array];
    for (ShopBrandLetterInfo *product in self.allProducts) {
        // 搜索匹配改为从头开始
        if ([[self upper:product.brandName] hasPrefix:[self upper:strippedString]]) {
            [searchResults addObject:product];
        }
    }
    
    // hand over the filtered results to our search results table
    ShopSearchResultsController *tableController = (ShopSearchResultsController *)self.searchController.searchResultsController;

    tableController.allProducts = searchResults;
    [tableController.tableView reloadData];
}

// 转换大小写
- (NSString *)upper:(NSString *)str
{
    return [str uppercaseString];
}
@end
