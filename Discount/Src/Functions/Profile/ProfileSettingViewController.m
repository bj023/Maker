//
//  ProfileSettingViewController.m
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ProfileSettingViewController.h"
#import "XXFileHelper.h"
#import "ProfileDataManager.h"
#import "UIViewController+loginHelper.h"
#import "UserInfo.h"
#import "ProfileDataManager.h"

@interface ProfileSettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutView;


@end

@implementation ProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.hidesBottomBarWhenPushed = YES;
    self.sizeLabel.text = @"0.00M";
    [self updateSizeLabel];
    
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    if (!userInfo.isLogin) {
        self.logoutView.hidden = YES;
    }
    
}


- (IBAction)logoutAction:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    WEAKSELF(weakSelf);
    [ProfileDataManager logutResult:^(id data, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view.window animated:YES];
        if (data) {
            [MBProgressHUD showTextHUDAddedTo:weakSelf.view.window withText:data animated:YES];
            
            // 退出账号后回到首页
            UITabBarController *tabbarController = self.tabBarController;
            [self.navigationController popViewControllerAnimated:NO];
            [tabbarController setSelectedViewController:[tabbarController viewControllers][0]];
        }else{
            [MBProgressHUD showTextHUDAddedTo:weakSelf.view.window withText:MsgFromError(error) animated:YES];
        }
        
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self cleanCache];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        static NSString *const iRateiOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
        static NSString *const iRateiOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%@";

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iRateiOS7AppStoreURLFormat: iRateiOSAppStoreURLFormat, APP_ID]];
        [[UIApplication sharedApplication] openURL:url];
    
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UserInfo *userInfo = [ProfileDataManager userInfo:nil];
        if (!userInfo || ![userInfo.isLogin boolValue]) {
            [self showLoginViewController];
            return;
        }
    }
    
}


#pragma mark - private

- (void)cleanCache
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WEAKSELF(weakSelf);
    [XXFileHelper cleanAllCacheWithCompletionBlock:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        [MBProgressHUD showTextHUDAddedTo:weakSelf.view withText:@"清理完成" animated:YES];
        [self updateSizeLabel];
    }];
}

- (NSString *)cacheSize
{
    unsigned long long byteSize = [XXFileHelper folderSize:[XXFileHelper cachePath]];
    
    return [NSString stringWithFormat:@"%.2fM", byteSize*1.0/1024/1204];
}

- (void)updateSizeLabel
{
    __block NSString *size = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        size = [self cacheSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sizeLabel.text = size;
//            [self.sizeLable sizeToFit];
//            [self.cleanItem.cacheLable setNeedsDisplay];
        });
    });
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    UserInfo *userInfo  = [ProfileDataManager userInfo:nil];
    if (!userInfo) {
        if (self.tableView.indexPathForSelectedRow.section == 0) {
            return NO;
        }
    }
    
    return YES;
}

@end
