//
//  MenuViewController.m
//  Discount
//
//  Created by jackyzeng on 3/29/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "MenuHeaderView.h"
#import "BaseTabBarController.h"
#import "AboutViewController.h"
#import "BaseNavigationController.h"
#import "ProfileDataManager.h"
#import "ProfileViewController.h"
#import "ZLDrawerController.h"
#import "UIViewController+loginHelper.h"
#import "MenuFavViewController.h"
#import "MenuCouponViewController.h"
#import "UserInfo.h"
#import <SGImageCache/SGImageCache.h>

static CGFloat const kCellHeight = 50.0f;

static NSString *const kMenuCellIdentifier = @"MenuCellIdentifier";

@interface MenuViewController ()

@property(nonatomic, strong) NSArray *menus;
@property(nonatomic, strong) AboutViewController *about;
@property(nonatomic, weak) MenuHeaderView *menuHeaderView;
@property(nonatomic, strong) UserInfo *userInfo;

//- (void)showLoginViewController;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menus = @[@{@"title":@"首页", @"image":@"main_home"},
                   @{@"title":@"活动", @"image":@"main_discount"},
                   @{@"title":@"新品", @"image":@"main_newproduct"},
                   @{@"title":@"目的地", @"image":@"main_destination"},];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:kMenuCellIdentifier];
    self.menuHeaderView = (MenuHeaderView *)self.tableView.tableHeaderView;
    [self.menuHeaderView.likedButton addTarget:self action:@selector(onHeaderViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuHeaderView.qbButton addTarget:self action:@selector(onHeaderViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuHeaderView.headerButton addTarget:self action:@selector(onHeaderViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.backgroundColor = SS_HexRGBColor(0x282828);
    self.tableView.tableHeaderView.backgroundColor = SS_HexRGBColor(0x282828);
    UIButton *aboutButton = [[UIButton alloc] initWithFrame:CGRectMake((self.tableView.frame.size.width - 160) / 2, self.tableView.frame.size.height - 20 - 30, 160, 20)];
    aboutButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [aboutButton setTitleColor:SS_HexRGBColor(0x666666) forState:UIControlStateNormal];
    aboutButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [aboutButton setTitle:@"关于玩家惠" forState:UIControlStateNormal];
    [aboutButton addTarget:self action:@selector(onAbout:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:aboutButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkIsLogin];
}

- (void)checkIsLogin {
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    
    if ([userInfo.isLogin boolValue]) {
        [ProfileDataManager userInfo:^(id data, NSError *error) {
            if (data && !error) {
                self.userInfo = data;
                __weak typeof(self) me = self;
                [SGImageCache getImageForURL:self.userInfo.avatar].then(^(UIImage *image) {
                    [me.menuHeaderView.headerButton setImage:image forState:UIControlStateNormal];
                });
                
            }else{
                [MBProgressHUD showTextHUDAddedTo:self.view withText:MsgFromError(error) animated:YES];
            }
        }];
    }
}

- (BOOL)enableCustomBackground {
    return NO;
}

- (void)onDone:(id)sender {
    [self.about dismissViewControllerAnimated:YES completion:nil];
}

- (void)onAbout:(id)sender {
    if (!self.about) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AboutViewController *about = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(onDone:)];
        about.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.about = about;
    }
    BaseNavigationController *aboutNavigation = [[BaseNavigationController alloc] initWithRootViewController:self.about];
    [self presentViewController:aboutNavigation animated:YES completion:^{
        // do nothing
    }];
}

- (void)onHeaderViewButtonTapped:(UIButton *)button {
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    if (!userInfo || ![userInfo.isLogin boolValue]) {
        [self showLoginViewController];
        return;
    }
    
    NSString *controllerIdentifier = nil;
    if (button == self.menuHeaderView.likedButton) {
        controllerIdentifier = kFavViewControllerIdentifier;
    }
    else if (button == self.menuHeaderView.qbButton) {
        controllerIdentifier = kCouponViewControllerIdentifier;
    }
    else if (button == self.menuHeaderView.headerButton) {
        controllerIdentifier = kProfileViewControllerIdentifier;
    }
    
    if (controllerIdentifier) {
        UIViewController *controller = nil;
        if ([controllerIdentifier isEqualToString:kFavViewControllerIdentifier]) {
            controller = [MenuFavViewController new];
        }
        else if ([controllerIdentifier isEqualToString:kCouponViewControllerIdentifier]) {
            controller = [MenuCouponViewController new];
        }
        else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
            
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(dismissPresentedViewController:)];
            controller.navigationItem.rightBarButtonItem = doneItem;
        }
        [controller removeBackItem];
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

//- (void)showLoginViewController
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kLoginRegisterStoryboard bundle:nil];
//    UIViewController *loginViewController = [storyboard instantiateInitialViewController];
//    [self presentViewController:loginViewController animated:YES completion:^{
//        // completion
//    }];
//}

- (void)dismissPresentedViewController:(id)sender {
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menus.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *menuInfo = self.menus[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:menuInfo[@"image"]];
    cell.nameLabel.text = menuInfo[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *centerController = [self.mm_drawerController centerViewController];
    if ([centerController isKindOfClass:[BaseTabBarController class]]) {
        BaseTabBarController *tabbarController = (BaseTabBarController *)centerController;
        [tabbarController setSelectedIndex:(indexPath.row)];
        if ([tabbarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)tabbarController.selectedViewController popToRootViewControllerAnimated:NO];
        }
    }
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        if (indexPath.row != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackNav" object:nil];
        }
    }];
}

@end
