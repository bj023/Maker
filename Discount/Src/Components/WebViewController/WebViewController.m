//
//  WebViewController.m
//  Discount
//
//  Created by jackyzeng on 3/17/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "WebViewController.h"
#import "UIViewController+BackItem.h"
#import "LikeShareControl.h"
#import "ShareDataManager.h"
#import "NetAPI+Share.h"
#import "HomeDataManager.h"

@interface WebViewController () <UIWebViewDelegate>

@property(nonatomic, assign) BOOL toolbarHidden;
@property(nonatomic, strong) NSArray *webviewToolbarItems;
@property(nonatomic, retain) LikeShareControl * likeShareControl;
@property(nonatomic, retain) ShareItem *shareItem;


@end

@implementation WebViewController


- (instancetype)initWithURLString:(NSString *)urlString {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    

    NSArray *toolbarItems = nil;
    LikeShareControl *control = [[LikeShareControl alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    // todo refact
    control.itemID  = self.itemID;
    control.vc      = self;
    control.type    = @(self.type);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:control];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbarItems = @[space1, item, space2];
    self.likeShareControl = control;
    
    return [self initWithURLString:urlString toolbarItems:toolbarItems];
}

- (instancetype)initWithURLString:(NSString *)urlString toolbarItems:(NSArray *)toolbarItems {
    if (self = [super initWithNibName:@"WebViewController" bundle:nil]) {
        self.url = [NSURL URLWithString:urlString];
        self.webviewToolbarItems = toolbarItems;

        self.toolbarHidden = (self.webviewToolbarItems.count == 0);
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setupBackItem];
    
    if (!self.toolbarHidden) {
        self.toolbarItems = self.webviewToolbarItems;
    }
    
    // should not be crashed
    if (self.itemID == nil) {
        self.itemID = @(0);
    }
    self.shareItem = [ShareDataManager shareItemForType:[self shareType]
                                                 withID:self.itemID
                                                 result:^(id data, NSError *error) {
                                                     self.shareItem = data;
                                                 }];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)initialize {
    // 获取 iOS 默认的 UserAgent，可以很巧妙地创建一个空的UIWebView来获取：
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    // 获取App名称，我的App有本地化支持，所以是如下的写法
    NSString *appName = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
    // 如果不需要本地化的App名称，可以使用下面这句
    // NSString * appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@/%@/traveler99.com", appName, version];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
}

- (ShareItemType)shareType {
    ShareItemType type = ShareItemTypeNone;
    if (self.type == 1) {
        type = ShareItemTypeEvent;
    }
    else if (self.type == 2) {
        type = ShareItemTypeGuide;
    }
    else if (self.type == 3) {
        type = ShareItemTypeGoods;
    }
    
    return type;
}

- (void)setShareItem:(ShareItem *)shareItem {
    _shareItem = shareItem;
    
    _likeShareControl.shareItem = shareItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.toolbarHidden) {
        [self.navigationController setToolbarHidden:NO animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    self.likeShareControl.type = @(type);
    
//    if (self.type == 1) {
//        self.toolbarHidden = YES;
//    }

}

- (void)setItemID:(NSNumber *)itemID
{
    _itemID = itemID;
    SSLog(@"%@",_itemID);
    self.likeShareControl.itemID = itemID;
    
    if (self.type == 1) {
        [self receiveAdiscount];
    }else if(self.type == 2 || self.type == 3){
        [self getLikeState];
    }
}

- (void)setLiked:(BOOL)liked
{
    //SSLog(@"设置喜欢状态");
    _liked = liked;
    //self.likeShareControl.liked = liked;
}


#pragma -mark 请求喜欢接口
- (void)getLikeState
{
    if ([self.itemID intValue] == 0) {
        return;
    }
    [HomeDataManager likeStateWithItem:self.type ItemID:self.itemID result:^(id data, NSError *error) {
        if (data) {
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            SSLog(@"喜欢状态:json->%@",[data[@"data"] objectForKey:@"favorite"]);
            
            
            if ([data[@"code"] isEqualToString:@"000000"]) {
                if ([[data[@"data"] objectForKey:@"favorite"] boolValue]) {
                    self.likeShareControl.liked = YES;
                    
                }else
                    self.likeShareControl.liked = NO;
            }
            
        }
    }];
}

- (void)receiveAdiscount
{
    [HomeDataManager getReceiveAdiscountWithItem:self.itemID result:^(id data, NSError *error) {
        SSLog(@"receiveAdiscountWithItem->%@",data);
        
        //SSLog(@"%@",[[data objectForKey:@"data"] objectForKey:@"has_get"]);
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        if (![[json objectForKey:@"code"] isEqualToString:@"000000"]) {
            return ;
        }
        
        NSString * coupon = [[json objectForKey:@"data"] objectForKey:@"has_coupon"];
        NSString * has_get = [[json objectForKey:@"data"] objectForKey:@"has_get"];
        
        if ([coupon isEqualToString:@"1"]) {
            self.likeShareControl.shareBtn.hidden = YES;
            self.likeShareControl.lineView.hidden = NO;
            self.likeShareControl.shareButton.hidden = NO;
            // 有优惠券
            if (![has_get isEqualToString:@"1"]) {
                // 未领取过
                [self.likeShareControl.likeButton setTitle:@"领取优惠券" forState:UIControlStateNormal];
                [self.likeShareControl.likeButton setImage:[UIImage imageNamed:@"discount"] forState:UIControlStateNormal];
                self.likeShareControl.likeButton.backgroundColor = [UIColor colorWithRed:1 green:0 blue:60/255 alpha:1];
                [self.likeShareControl.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            }else{
                self.likeShareControl.likeButton.enabled = YES;
                self.likeShareControl.likeButton.userInteractionEnabled = NO;
                [self.likeShareControl.likeButton setTitle:@"已领取优惠券" forState:UIControlStateNormal];
                [self.likeShareControl.likeButton setImage:[UIImage imageNamed:@"discount_select"] forState:UIControlStateNormal];
                self.likeShareControl.likeButton.backgroundColor = [UIColor whiteColor];
                [self.likeShareControl.likeButton setTitleColor: [UIColor colorWithRed:1 green:0 blue:60/255 alpha:1] forState:UIControlStateNormal];

            }
        }else{
            
            self.likeShareControl.likeButton.hidden = YES;
            self.likeShareControl.lineView.hidden = YES;
            self.likeShareControl.shareButton.hidden = YES;
            self.likeShareControl.shareBtn.hidden = NO;
            //[self.navigationController setToolbarHidden:YES animated:NO];
        }
        
    }];
}
@end
