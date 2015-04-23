//
//  ProfileViewController.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "ProfileDataManager.h"
#import "UIViewController+loginHelper.h"
#import "FavViewController.h"
#import "FavNewProductViewController.h"
#import "FavShopViewController.h"
#import "FavRaidersViewController.h"
#import "ProDataManager.h"
#import "MessageAndCoupon.h"



@interface ProfileViewController ()

@property(nonatomic, strong) UserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageIMG;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userInfo = [ProfileDataManager userInfo:nil];
    
    //SSLog(@"%@",self.userInfo.cookie);
    

    MessageAndCoupon *messageAndCoupon = [ProDataManager messageCouponCountResult:nil];
    
    [self updateCount:messageAndCoupon];
    
    
}

- (void)updateCount:(MessageAndCoupon *)messageAndCoupon
{
    self.messageCountLabel.hidden = YES;
    self.messageIMG.hidden = YES;

    self.couponCountLabel.hidden = YES;
    self.couponLabel.hidden = YES;
    
    if (messageAndCoupon) {
        self.messageCountLabel.text = [NSString stringWithFormat:@"%@", messageAndCoupon.messageCount];
        self.couponCountLabel.text = [NSString stringWithFormat:@"%@", messageAndCoupon.couponCount];
        
        if ([messageAndCoupon.couponCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
            self.couponCountLabel.hidden = YES;
            self.couponLabel.hidden = YES;
        }else
        {
            self.couponCountLabel.hidden = NO;
            self.couponLabel.hidden = NO;
        }
        
        if ([messageAndCoupon.messageCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
            self.messageCountLabel.hidden = YES;
            self.messageIMG.hidden = YES;
        }else
            self.messageIMG.hidden = NO;
            self.messageCountLabel.hidden = NO;
    }
}

- (void)loadDefaultUserInfo
{
    self.avatarImageView.image = [UIImage imageNamed:@"login_header_default"];
    self.nickNameLabel.text = @"未登录";
    self.addressLabel.text = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    
    if ([userInfo.isLogin boolValue]) {
        [ProfileDataManager userInfo:^(id data, NSError *error) {
            if (data && !error) {
                
                self.userInfo = data;
                
                if (IsEmpty(self.userInfo.avatar)) {
                    self.avatarImageView.image = [UIImage imageNamed:@"login_header_default"];

                }else
                    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar]];
                self.nickNameLabel.text = self.userInfo.nickName;
                NSString *sex = SEXSTRBY(self.userInfo.sex.integerValue);
                
                // 要去掉 
                self.addressLabel.text = [NSString stringWithFormat:@"%@ - %@ %@", self.userInfo.province, self.userInfo.city, sex];
            }else{
                [MBProgressHUD showTextHUDAddedTo:self.view withText:MsgFromError(error) animated:YES];
            }
        }];
        
        [ProDataManager messageCouponCountResult:^(id data, NSError *error) {
            [self updateCount:data];
        }];
    }else{
    
        MessageAndCoupon * messageAndCoupon = [MessageAndCoupon MR_createEntity];
        messageAndCoupon.messageCount = @(0);
        messageAndCoupon.couponCount = @(0);
        [self updateCount:messageAndCoupon];
        
        [self loadDefaultUserInfo];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    
    [super viewWillDisappear:animated];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section != 2) {
        UserInfo *userInfo = [ProfileDataManager userInfo:nil];
        if (!userInfo || ![userInfo.isLogin boolValue]) {
            [self showLoginViewController];
            return;
        }
    }
    
    if (indexPath.section == 0 && indexPath.row == 1  ) {
        [self goFavViewController];
    }
}


#pragma mark - private

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    UserInfo *userInfo  = [ProfileDataManager userInfo:nil];
    if (!userInfo) {
        if (self.tableView.indexPathForSelectedRow.section != 2) {
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    
    [super prepareForSegue:segue sender:sender];
}

- (void)goFavViewController{
    

    FavShopViewController *shop = [FavShopViewController new];
    
    
    FavNewProductViewController *product = [FavNewProductViewController new];
    

    FavRaidersViewController *raiders = [FavRaidersViewController new];

    shop.title = @"商场";
    product.title = @"新品";
    raiders.title = @"攻略";
    
    NSArray *viewControllers = @[shop, product, raiders];
    FavViewController *shopViewController = [[FavViewController alloc] initWithViewControllers:viewControllers];
    shopViewController.title = @"喜欢";
    
    [self pushViewControllerInNavgation:shopViewController animated:YES];
}

@end
