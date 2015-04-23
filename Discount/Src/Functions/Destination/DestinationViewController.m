//
//  DestinationViewController.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "DestinationViewController.h"
#import "DestinationTableViewCell.h"
#import "DestinationAddressTableViewCell.h"
#import "ShopDataManager.h"
#import "HomeBournRegion.h"
#import "HomeBournShop.h"
#import "IBDestinationHeaderView.h"

@interface DestinationViewController () <DestinationHeaderViewDelegate>

@property(nonatomic, strong) IBOutlet IBDestinationHeaderView *header;
@property(nonatomic, assign) NSInteger selectRow;
@property(nonatomic, assign) BOOL      isOpened;
@property(nonatomic, strong) HomeBourn *bourn;
@property(nonatomic, strong) NSMutableArray *openedArr;

- (void)ensureValidDestination;

@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ensureValidDestination];
    
    self.header.shouldHideMarkLine = NO;
    self.header.dest = self.destination;
    
    self.selectRow = -1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DestinationTableViewCell" bundle:nil] forCellReuseIdentifier:DestinationTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DestinationAddressTableViewCell" bundle:nil] forCellReuseIdentifier:DestinationAddressTableViewCellIdentifier];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"shopCell"];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self fetchBournDataWithDestination:self.destination];
}

- (void)ensureValidDestination {
    if (_destination < E_DESITION_BEGIN || _destination >= E_DESITION_END) {
        _destination = E_DESITION_ASIA;
    }
}

- (void)fetchBournDataWithDestination:(E_DESITION)destination {
    self.bourn = [ShopDataManager bournByID:@(_destination) result:^(id data, NSError *error) {
        if (!error && data) {
            self.bourn = data;
            [self initOpenedArr];
            [self.tableView reloadData];
        }
    }];
    
    if (self.bourn) {
        [self initOpenedArr];
        [self.tableView reloadData];
    }
}

- (void)setDestination:(E_DESITION)destination {
    _destination = destination;
    [self ensureValidDestination];
    
    [self.header setDest:destination];
    
    [self fetchBournDataWithDestination:_destination];
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[self.bourn.regions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bourn.regions count];//[[self.bourn.regions[section] shops] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    HomeBournRegion *region = self.bourn.regions[section];
//    return region.region;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
//    HomeBournRegion *region = self.bourn.regions[indexPath.section];
//    HomeBournShop *shop = region.shops[indexPath.row];
//    cell.textLabel.text = shop.shopName;
//    
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.openedArr[indexPath.row] boolValue]) {
        return 60 + 30 + 60 * [self.bourn.regions[indexPath.row] shops].count;
    }
    return 60;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if ([self.openedArr[indexPath.row] boolValue]) {
            DestinationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DestinationTableViewCellIdentifier forIndexPath:indexPath];
        
        cell.dataSource = [[self.bourn.regions[indexPath.row] shops] array];
        HomeBournRegion *region = self.bourn.regions[indexPath.row];
        cell.addressName.text = region.region;
        cell.viewController = self;
        [cell reload];
        
        return cell;
    }

    DestinationAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DestinationAddressTableViewCellIdentifier forIndexPath:indexPath];
    
    HomeBournRegion *region = self.bourn.regions[indexPath.row];
    cell.addressName.text = region.region;
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL isOpend = [self.openedArr[indexPath.row] boolValue];
    self.openedArr[indexPath.row] = @(!isOpend);

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (!isOpend) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark - DestinationHeaderViewDelgate

- (void)view:(IBDestinationHeaderView *)view didSelectDestination:(E_DESITION)destination {
    self.destination = destination;
}


#pragma mark - private

- (void)initOpenedArr
{
    NSInteger regionCount = [self.bourn.regions count];
    
    if (self.openedArr == nil || self.openedArr.count != regionCount) {
        self.openedArr = [NSMutableArray arrayWithCapacity:regionCount];
        for (int i = 0; i < regionCount; i++) {
            self.openedArr[i] = @(NO);
        }
    }
    
}
@end
