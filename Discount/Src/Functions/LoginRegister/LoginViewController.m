//
//  LoginViewController.m
//  Discount
//
//  Created by jackyzeng on 3/23/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "LoginViewController.h"
#import "IBSocialLoginView.h"
#import "UIButton+tintImage.h"
#import "NetAPI.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"


@interface LoginViewController () <UITextFieldDelegate, SocialLoginViewDelegate >

@property(nonatomic, strong) IBOutlet UIView *fieldContainer;
@property(nonatomic, strong) IBOutlet UITextField *userField;
@property(nonatomic, strong) IBOutlet UITextField *passwordField;
@property(nonatomic, strong) IBOutlet UIButton *loginButton;

@property(nonatomic, strong) NSDataDetector *detector;

- (void)dismiss;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = NULL;
    self.detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                               error:&error];
    
    self.fieldContainer.layer.borderWidth = 1;
    self.fieldContainer.layer.borderColor = [SS_HexRGBColor(0xebebeb) CGColor];
    self.fieldContainer.layer.cornerRadius = 4.0f;
    
    self.loginButton.layer.cornerRadius = 4.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
//#ifndef NDEBUG
//    // TEST data
//    NSString *phone = @"18513235620";
//    NSString *pass = @"123456";
//    self.userField.text = phone;
//    self.passwordField.text = pass;
//#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // do not show keyboard when view appeared
    // [self.userField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.userField.isFirstResponder) {
        [self.userField resignFirstResponder];
    }
    if (self.passwordField.isFirstResponder) {
        [self.passwordField resignFirstResponder];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    SSLog(@"%@", notification);
    // TODO(jacky):如果用户在第三方授权登录时，如果不点击授权或取消，直接切回应用，有可能会任何授权的回调都无法正常接收(如微信)。
    // 此处应该增加逻辑判断，若用户从后台唤醒app，一段时间后应该hide所有HUDs。
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)onClose:(id)sender {
    [self dismiss];
}

- (IBAction)onLogin:(id)sender {
    BOOL shouldShowAlert = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请重新输入" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    if (self.userField.text.length == 0) {
        alert.title = @"请输入手机号";
    }
    else if ([self.userField.text length] != 11) {
        alert.title = @"手机号位数不对";
    }
    else if (self.passwordField.text.length == 0) {
        alert.title = @"请输入密码";
    }
    else if (self.passwordField.text.length < 6 || self.passwordField.text.length > 16) {
        alert.title = @"密码必须是6-16位";
    }
    else if (![self checkIfValidPhone:self.userField.text]) {
        alert.title = @"请输入有效的手机号";
    }
    else {
        shouldShowAlert = NO;
        
        AFHTTPRequestOperation *op = [NetAPI operationForLoginWithPhone:self.userField.text
                                                                password:self.passwordField.text
                                                                 success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
             NSString *title = @"";
             NSString *message = @"";
             if ([data[@"code"] integerValue] != 0) {
                 title = @"登录失败";

                 message = data[@"msg"];
                 
                 MBProgressHUD *hud = [MBProgressHUD showTextHUDAddedTo:self.view withText:title animated:YES completionBlock:nil];
                 if (message.length > 0) {
                     hud.detailsLabelText = message;
                 }

             }else {
                 title = @"登录成功";
                 
                 NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[[operation response] URL]];
                 
                 [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                     UserInfo *userInfo = [UserInfo MR_findFirstInContext:localContext];
                     if (!userInfo) {
                         userInfo = [UserInfo MR_createInContext:localContext];
                     }
                     
                     userInfo.isLogin = @(YES);
                     userInfo.cookie = [NSKeyedArchiver archivedDataWithRootObject:cookies];

                 }];
                 
                 WEAKSELF(weakSelf);
                 MBProgressHUD *hud = [MBProgressHUD showTextHUDAddedTo:self.view withText:title animated:YES completionBlock:^{
                     [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                         
                     }];
                 }];
                 if (message.length > 0) {
                     hud.detailsLabelText = message;
                 }
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MBProgressHUD *hud = [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录失败" animated:YES];
             hud.detailsLabelText = @"网络异常,请稍后重试";
         }];
        
        [op start];
    }
    
    if (shouldShowAlert) {
        [alert show];
    }
}

- (BOOL)checkIfValidPhone:(NSString *)string {
    NSArray *matches = [self.detector matchesInString:string
                                              options:0
                                                range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypePhoneNumber) {
            NSString *phoneNumber = [match phoneNumber];
            SSLog(@"match phone = %@", phoneNumber);
            return YES;
        }
    }
    
    return NO;
}

- (void)hideAllHuds {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideHudsAndDismiss {
    [self hideAllHuds];
    [self dismiss];
}

#pragma mark - SocialLoginViewDelegate

- (void)socialLoginView:(IBSocialLoginView *)view loginWithType:(SocialShareType)type {
    WEAKSELF(weakSelf);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate loginWithType:type inController:self completion:^(UMSocialResponseEntity *response) {
        [self hideAllHuds]; // hide old hud
        if ((response.responseCode == UMSResponseCodeSuccess)) {
            
            UMSocialAccountEntity *snsAccount;
            if (type == SocialShareTypeSinaWeibo) {
                snsAccount = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToSina];
                [weakSelf UMSocialAccountSinaLogin:type AccessToken:snsAccount.accessToken UserID:snsAccount.usid];
            }
            else if (type == SocialShareTypeQQ){
                snsAccount = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToQzone];
                [weakSelf UMSocialAccountQQLogin:type AccessToken:snsAccount.accessToken UserID:snsAccount.usid];
            }
            else if (type == SocialShareTypeWeChatSession){
                snsAccount = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToWechatSession];
                [weakSelf UMSocialAccountQQLogin:type AccessToken:snsAccount.accessToken UserID:snsAccount.usid];
            }
            
            SSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
            
            //SSLog(@"%@：第三方登录成功", NSStringFromClass([weakSelf class]));
            
        }
        else {
            [MBProgressHUD showTextHUDAddedTo:self.view withText:@"第三方登录失败" animated:YES];
//            [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录失败" animated:YES];
//            [weakSelf performSelector:@selector(hideAllHuds) withObject:nil afterDelay:1.0];
        }
    }];
}

// 登陆
- (void)UMSocialAccountSinaLogin:(NSInteger)type AccessToken:(NSString *)accessToken UserID:(NSString *)userId
{
    AFHTTPRequestOperation * op = [NetAPI operationForUMSocialType:type AccessToken:accessToken UserID:userId Success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        
        if (data && [data[@"code"] integerValue] == 0) {
            // 注册成功
            
            NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[[operation response] URL]];
            
            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                UserInfo *userInfo = [UserInfo MR_findFirstInContext:localContext];
                if (!userInfo) {
                    userInfo = [UserInfo MR_createInContext:localContext];
                }
                
                userInfo.isLogin = @(YES);
                userInfo.cookie = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                
            }];
            [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录成功" animated:YES];
            [self hideHudsAndDismiss];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录失败" animated:YES];
        [self hideAllHuds];
    }];
    
    [op start];
}

- (void)UMSocialAccountQQLogin:(NSInteger)type AccessToken:(NSString *)accessToken UserID:(NSString *)userId
{
    AFHTTPRequestOperation * op = [NetAPI operationForUMSocialType:type AccessToken:accessToken UserID:userId Success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        if (data && [data[@"code"] integerValue] == 0) {
            // 注册成功
            
            NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[[operation response] URL]];
            
            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                UserInfo *userInfo = [UserInfo MR_findFirstInContext:localContext];
                if (!userInfo) {
                    userInfo = [UserInfo MR_createInContext:localContext];
                }
                
                userInfo.isLogin = @(YES);
                userInfo.cookie = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                
            }];
            [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录成功" animated:YES];
            [self hideHudsAndDismiss];
        }
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录失败" animated:YES];
        [self hideAllHuds];
        
    }];
    
    [op start];
}

- (void)UMSocialAccountWechtLogin:(NSInteger)type AccessToken:(NSString *)accessToken UserID:(NSString *)userId
{
    AFHTTPRequestOperation * op = [NetAPI operationForUMSocialType:type AccessToken:accessToken UserID:userId Success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        
        if (data && [data[@"code"] integerValue] == 0) {
            // 注册成功
            
            NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[[operation response] URL]];
            
            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                UserInfo *userInfo = [UserInfo MR_findFirstInContext:localContext];
                if (!userInfo) {
                    userInfo = [UserInfo MR_createInContext:localContext];
                }
                
                userInfo.isLogin = @(YES);
                userInfo.cookie = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                
            }];
            [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录成功" animated:YES];
            [self hideHudsAndDismiss];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录失败" animated:YES];
        [self hideAllHuds];
    }];
    
    [op start];
}

#pragma mark - UITextFieldDelegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField == self.userField) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [self onLogin:textField];
    }
    
    return YES;
}

@end
