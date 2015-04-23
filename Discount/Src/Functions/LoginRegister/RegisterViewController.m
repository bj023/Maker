//
//  RegisterViewController.m
//  Discount
//
//  Created by jackyzeng on 3/23/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerifyViewController.h"
#import "WebViewController.h"
#import "BaseNavigationController.h"
#import "UserAgreementViewController.h"
#import "IBSocialLoginView.h"
#import "AppDelegate.h"
#import "NetAPI.h"

static NSString *kPerformVerifyControllerIdentifier = @"PerformVerifyController";

@interface RegisterViewController () <UITextFieldDelegate, SocialLoginViewDelegate>

@property(nonatomic, strong) IBOutlet UIView *fieldContainer;
@property(nonatomic, strong) IBOutlet UITextField *userField;
@property(nonatomic, strong) IBOutlet UITextField *nickNameField;
@property(nonatomic, strong) IBOutlet UITextField *passwordField;
@property(nonatomic, strong) IBOutlet UITextField *confirmFiled;
@property(nonatomic, strong) IBOutlet UIButton *registerButton;

@property(nonatomic, strong) NSDataDetector *detector;

- (void)registerToServer;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = NULL;
    self.detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                    error:&error];
    self.fieldContainer.layer.borderWidth = 1;
    self.fieldContainer.layer.borderColor = [SS_HexRGBColor(0xebebeb) CGColor];
    self.fieldContainer.layer.cornerRadius = 4.0f;
    
    self.registerButton.layer.cornerRadius = 4.0f;
   
//#ifndef NDEBUG
//    // TEST data
//    NSString *phone = @"18513235620";
//    NSString *pass = @"123456";
//    self.userField.text = phone;
//    self.nickNameField.text = @"玩家惠惠";
//    self.passwordField.text = pass;
//    self.confirmFiled.text = pass;
//#endif
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // do not show keyboard when view appeared
    // [self.userField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.vcode.length > 0) {
//        [self registerToServer];
//    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)onRegister:(id)sender {
    NSString *alertTitle = nil;
    if (self.userField.text.length == 0) {
        alertTitle = @"请输入手机号";
    }
    else if ([self.userField.text length] != 11) {
        alertTitle = @"手机号位数不对";
    }
    else if ([self.nickNameField.text length] == 0) {
        alertTitle = @"请输入昵称";
    }
    else if ([self.passwordField.text length] == 0) {
        alertTitle = @"请输入密码";
    }
    else if ([self.passwordField.text length] < 6 || [self.passwordField.text length] > 16) {
        alertTitle = @"密码必须是6-16位";
    }
    else if (![self.passwordField.text isEqualToString:self.confirmFiled.text]) {
        alertTitle = @"两次密码不一致，请重新输入";
    }
    else if (![self checkIfValidPhone:self.userField.text]) {
        alertTitle = @"请输入有效的手机号";
    }
    else {
        [self sendPhoneNumberCode:sender];
        
        /*
        if (self.vcode == nil || self.vcode.length == 0) {
//            [self performSegueWithIdentifier:kPerformVerifyControllerIdentifier
//                                      sender:sender];
        }
        else {
            [self registerToServer];
        }
         */
    }
    
    if (alertTitle.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
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
//18612980092
- (void)registerToServer {
    AFHTTPRequestOperation *op = [NetAPI operationForRegWithPhone:self.userField.text
                                                         nickName:self.nickNameField.text
                                                         password:self.passwordField.text
                                                            vcode:self.vcode
                                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                                                              SSLog(@"%@",data);
                                                              NSString *title = @"";
                                                              NSString *message = @"";
                                                              NSString *uid = nil;
                                                              if ([data[@"code"] integerValue] != 0) {
                                                                  title = @"注册失败";
//#ifndef NDEBUG
//                                                                  message = [NSString stringWithFormat:@"错误码：%@\n详情：%@", data[@"code"], data[@"msg"]];
//#else
                                                                  message = data[@"msg"];
//#endif
                                                              }
                                                              else {
                                                                  uid = [data[@"data"] stringForKey:@"uid"];
                                                                  title = @"注册成功";
                                                                  message = [NSString stringWithFormat:@"uid = %@", uid];
                                                              }
                                                              
                                                              MBProgressHUD *hud = [MBProgressHUD showTextHUDAddedTo:self.view withText:title animated:YES];
                                                              if (message.length > 0) {
                                                                  hud.detailsLabelText = message;
                                                              }
                                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              MBProgressHUD *hud = [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录失败" animated:YES];
                                                              hud.detailsLabelText = error.localizedDescription;
                                                          }];
    
    [op start];
}

#pragma -mark 校验手机号
- (void)sendPhoneNumberCode:(id)sender
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak RegisterViewController *weakSelf = self;
    AFHTTPRequestOperation *op = [NetAPI operationForVcodeWithPhone:self.userField.text nickName:self.nickNameField.text success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        SSLog(@"%@",data);
        
        if ([data[@"code"] integerValue] != 0) {
            NSString *message = data[@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showTextHUDAddedTo:self.view withText:@"" animated:YES];
            if (message.length > 0) {
                hud.detailsLabelText = message;
            }
        }
        else {

            [weakSelf performSegueWithIdentifier:kPerformVerifyControllerIdentifier sender:sender];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showTextHUDAddedTo:self.view withText:@"获取验证码失败" animated:YES];
        hud.detailsLabelText = error.localizedDescription;
    }];
    
    [op start];
}

- (IBAction)onUserAgerement:(id)sender {
    UserAgreementViewController *agreeController = [UserAgreementViewController new];
    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:agreeController];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark -

// we just handle the segue action ourself
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:kPerformVerifyControllerIdentifier]) {
        return NO;
    }
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kPerformVerifyControllerIdentifier]) {
        VerifyViewController *verifyController = segue.destinationViewController;
        verifyController.phoneNumber = self.userField.text;
        verifyController.nikName = self.nickNameField.text;
        verifyController.password = self.passwordField.text;
        verifyController.registerController = self;
        [verifyController fireTimerIfNeed];
    }
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
            SSLog(@"%@：第三方登录成功", NSStringFromClass([weakSelf class]));
            [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录成功" animated:YES];
            [weakSelf hideHudsAndDismiss];
        }
        else {
            [MBProgressHUD showTextHUDAddedTo:self.view withText:@"登录失败" animated:YES];
            [weakSelf performSelector:@selector(hideAllHuds) withObject:nil afterDelay:1.0];
        }
    }];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.userField) {
        [self.nickNameField becomeFirstResponder];
    }
    else if (textField == self.nickNameField) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [self.confirmFiled becomeFirstResponder];
    }
    else if (textField == self.confirmFiled) {
        [self onRegister:textField];
    }
    
    return YES;
}

@end
