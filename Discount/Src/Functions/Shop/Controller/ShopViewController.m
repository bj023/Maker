//
//  ShopViewController.m
//  Discount
//
//  Created by jackyzeng on 3/4/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopViewController.h"

#import "ShopRebateViewController.h"
#import "ShopHomeViewController.h"
#import "ZLDrawerController.h"
#import "ShopGuidesViewController.h"

@interface ShopViewController ()

@property(nonatomic) NSInteger selectedIndex;

- (CGRect)frameForContentController;
- (void)switchContentControllerFrom:(UIViewController *)fromController to:(UIViewController *)toController;

@end

@implementation ShopViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    return [self initWithViewControllers:viewControllers selectAt:0];
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers selectAt:(NSInteger)index {
    if (self = [super initWithNibName:@"ShopViewController" bundle:nil]) {
        self.viewControllers = viewControllers;
        self.selectedIndex = index;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavTitle:(NSNotification *)notification
{
    NSString *title = notification.object;
    self.title = title;
}

- (void)navigationBack:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavTitle:) name:@"setNavTitle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationBack:) name:@"BackNav" object:nil];
        
    NSMutableArray *titles = [NSMutableArray array];
    for (UIViewController *controller in self.viewControllers) {

        if (controller.title != nil) {
            [titles addObject:controller.title];
        }
        else {
            [titles addObject:@""];
        }
    }
    [self.switcher setTitles:titles];
    [self.switcher selectIndex:self.selectedIndex];
    [self onSwitcherSelected:self.switcher];
    [self.switcher addTarget:self action:@selector(onSwitcherSelected:) forControlEvents:UIControlEventValueChanged];
    
    [self setupBackItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shop_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    if (self.hasMoreMessage) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"shop_menu_more"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.tabBarController.tabBar setHidden:YES];
}

- (CGRect)frameForContentController {
    CGFloat offsetY = self.switcher.frame.origin.y + self.switcher.frame.size.height + 1; // 1 is shadow offset
    
    return CGRectMake(0, offsetY, self.view.frame.size.width, self.view.frame.size.height - offsetY);
}

- (void)switchContentControllerFrom:(UIViewController *)fromController to:(UIViewController *)toController {
    if (fromController) {
        [fromController willMoveToParentViewController:nil];
        [fromController.view removeFromSuperview];
        [fromController removeFromParentViewController];
    }
    
    if (toController) {
        [self addChildViewController:toController];
        toController.view.frame = [self frameForContentController];
        [self.view addSubview:toController.view];
        [toController didMoveToParentViewController:self];
        
        self.topViewController = toController;
    }
}

- (void)onSwitcherSelected:(ShopViewSwitcher *)switcher {
    SSLog(@"ShopViewSwitcher select index at: %ld", (long)switcher.selectedIndex);
    
    UIViewController *toController = self.viewControllers[switcher.selectedIndex];
        
    if ([NSClassFromString(@"ShopGuidesViewController") isSubclassOfClass:toController.class]) {
        if (switcher.shopType == ShopBrandType) {
            ShopGuidesViewController *shopGuiVC = (ShopGuidesViewController*)toController;
            [shopGuiVC clickFindLocationWithBrandID:switcher.brandID Floor:switcher.floor];
        }
        else if (switcher.shopType == ShopRebateType){
            ShopGuidesViewController *shopGuiVC = (ShopGuidesViewController*)toController;
            [shopGuiVC clickFindLocationWithServiceID:switcher.serviceID Floor:switcher.floor];
        }else{
            ShopGuidesViewController *shopGuiVC = (ShopGuidesViewController*)toController;
            [shopGuiVC clickFindLocation];
        }
    }
    
    [self switchContentControllerFrom:self.topViewController to:toController];
}

- (void)onBack:(UIBarButtonItem *)sender {
//    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onMenu:(UIBarButtonItem *)sender {
    SSLog(@"menu pressed");
    
    
    
    if (self.tabBarController.mm_drawerController) {
        [self.tabBarController.mm_drawerController toggleDrawerSide:MMDrawerSideRight
                                                           animated:YES completion:^(BOOL finished) {
                                                               // todo
                                                           }];
    }
}

@end
