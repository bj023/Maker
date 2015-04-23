//
//  BaseTabBarController.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "BaseTabBarController.h"
#import "Reachability.h"

static CGFloat const kNoNetworkViewHeight = 30.0f;

static NSString *selectedImages[] = {
    @"main_home_sel",
    @"main_discount_sel",
    @"main_newproduct_sel",
    @"main_destination_sel",
    @"main_profile_sel",
};

@interface NoNetworkView : UIView

@property(nonatomic, strong) UILabel *textLabel;

@end

@implementation NoNetworkView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_textLabel setTextColor:SS_HexRGBColor(0x999999)];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_textLabel setText:@"当前没有网络连接，请检查网络并重试"];
        [self addSubview:_textLabel];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    return self;
}

@end

@interface BaseTabBarController ()

@property(nonatomic, strong) NoNetworkView *noNetworkView;
@property(nonatomic, strong) Reachability *internetReachability;

- (void)showNoNetworkView:(BOOL)show animated:(BOOL)animated;

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setTintColor:MAIN_THEME_COLOR];
    [self.tabBar setBarStyle:UIBarStyleDefault];
    [self.tabBar setTranslucent:NO];
    
    NSInteger imageCounts = Arraysize(selectedImages);
    for (NSInteger index = 0; index < self.tabBar.items.count && index < imageCounts; index++) {
        UITabBarItem *item = self.tabBar.items[index];
        item.selectedImage = [UIImage imageNamed:selectedImages[index]];
    }
    
    self.noNetworkView = [[NoNetworkView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kNoNetworkViewHeight)];
    self.noNetworkView.hidden = YES;
    [self.view addSubview:self.noNetworkView];
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
    
    SSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    [self showNoNetworkView:(reachability.currentReachabilityStatus == NotReachable) animated:NO];
}

- (void)showNoNetworkView:(BOOL)show animated:(BOOL)animated {
    CGFloat y = 0.0f;
    if (show) {
        UIViewController *controller = [self selectedViewController];
        if ([controller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)controller;
            if (!nav.navigationBarHidden) {
                y = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
            }
        }
    }
    CGRect frame = self.noNetworkView.frame;
    frame.origin.y = y;
    self.noNetworkView.frame = frame;
    self.noNetworkView.hidden = !show;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


@end
