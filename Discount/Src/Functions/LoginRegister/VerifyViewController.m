//
//  VerifyViewController.m
//  Discount
//
//  Created by jackyzeng on 3/23/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "VerifyViewController.h"
#import "RegisterViewController.h"
#import "NetAPI.h"
#import "UserInfo.h"

@interface VerifyViewController () <UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UILabel *userLabel;
@property(nonatomic, strong) IBOutlet UITextField *vcodeField;
@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UIButton *sendButton;
@property(nonatomic, strong) IBOutlet UIButton *doneButton;
@property(nonatomic, strong) IBOutlet UIView *fieldContainer;

@property(nonatomic, strong) NSString *vcode;
@property(nonatomic, strong) NSTimer *countdownTimer;
@property(nonatomic) NSInteger countDownSeconds;

- (void)fetchVCode;
- (void)vcodeUpdateTo:(NSString *)vcode;
- (void)updateDoneButtonStatus;

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userLabel.text = self.phoneNumber;
    
    self.fieldContainer.layer.borderWidth = 1;
    self.fieldContainer.layer.borderColor = [SS_HexRGBColor(0xebebeb) CGColor];
    
    self.doneButton.layer.cornerRadius = 4.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.vcodeField];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    if (self.vcodeField.text.length == 0) {
        self.doneButton.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self fireTimerIfNeed];
//    [self fetchVCode];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)onBack:(id)sender {
    [self back];
}

- (IBAction)onDone:(id)sender {
    //[self back];
    [self fetchVCode];
}

- (IBAction)onSend:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"发送"]) {
        [self fireTimerIfNeed];
        [self sendCode];
    }
}

- (void)back {
    self.registerController.vcode = self.vcodeField.text;
    [self.navigationController popViewControllerAnimated:NO];
    [self.registerController dismissViewControllerAnimated:NO completion:nil];
}

- (void)updateDoneButtonStatus {
    self.doneButton.enabled = (self.vcodeField.text.length > 0);
}

- (void)timerFired:(NSTimer *)timer {
    if (self.countDownSeconds == 0) {
        [self.sendButton setTitle:@"发送"
                         forState:UIControlStateNormal];
        [self.countdownTimer invalidate];
    }
    else {
        self.countDownSeconds -= 1;
    }
}

- (void)setCountDownSeconds:(NSInteger)countDownSeconds {
    _countDownSeconds = countDownSeconds;
    
    [UIView setAnimationsEnabled:NO];
    [self.sendButton setTitle:[NSString stringWithFormat:@"（%ld）重新发送", (long)_countDownSeconds]
                     forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:YES];
}

- (void)fireTimerIfNeed {
    if (self.countDownSeconds != 0) {
        return;
    }
    
    if (![self.countdownTimer isValid]) {
        self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(timerFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        self.countDownSeconds = 60;
    }
}

- (void)vcodeUpdateTo:(NSString *)vcode {
    self.vcode = vcode;
}

- (void)fetchVCode {
    /*
    [[NetAPI operationForVcodeWithPhone:self.user
                                success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                                    // handle success block
                                    SSLog(@"获取验证码成功, data = %@", data);
                                    if (data && [data[@"code"] integerValue] == 0) {
                                        [self vcodeUpdateTo:data[@"data"]];
                                    }
                                    else {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取注册码失败"
                                                                                        message:data[@"msg"]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:nil
                                                                              otherButtonTitles:@"确定", nil];
                                        [alert show];
                                    }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取注册码失败"
                                                                                    message:error.localizedDescription
                                                                                   delegate:nil
                                                                          cancelButtonTitle:nil
                                                                          otherButtonTitles:@"确定", nil];
                                    [alert show];
                                }] start];
     */
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperation *op = [NetAPI operationForRegWithPhone:self.phoneNumber
                                                         nickName:self.nikName
                                                         password:self.password
                                                            vcode:self.vcodeField.text
                                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
                                                              
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
            
            [self back];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    [op start];
}

- (void)sendCode
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    AFHTTPRequestOperation *op = [NetAPI operationForVcodeWithPhone:self.phoneNumber success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        SSLog(@"重新发送验证码%@",data);
        
        if (data && [data[@"code"] integerValue] == 0) {
            [MBProgressHUD showTextHUDAddedTo:self.view withText:@"发送成功" animated:YES];
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    [op start];
}

- (void)dealloc {
    if ([self.countdownTimer isValid]) {
        [self.countdownTimer invalidate];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateDoneButtonStatus];
}

- (void)textDidChanged:(id)sender {
    [self updateDoneButtonStatus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updateDoneButtonStatus];
    return YES;
}

@end
