//
//  ProfilePhoneViewController.m
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ProfilePhoneViewController.h"
#import "ProfileDataManager.h"
#import "UIColor+SSExt.h"

typedef enum : NSUInteger {
    BindStatus_phone,
    BindStatus_vcode,
    BindStatus_try,
} BindStatus;


@interface ProfilePhoneViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic, assign) BindStatus status;
@property (nonatomic, assign) NSInteger leftTime;
@property (nonatomic, retain) NSTimer *timer;;
@property (nonatomic, strong) NSString *phoneNum;
@end

@implementation ProfilePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTextField.delegate = self;
    self.nextBarButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)send:(id)sender {
    
    [self.view endEditing:YES];
    
    switch (self.status) {
        case BindStatus_phone:
        case BindStatus_try:
        {
            if (!self.inputTextField.text.length) {
                [MBProgressHUD showTextHUDAddedTo:self.view withText:@"电话号码不能为空" animated:YES];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.phoneNum = self.inputTextField.text;
                WEAKSELF(weakSelf);
                [ProfileDataManager vcodeForPhone:self.inputTextField.text result:^(id data, NSError *error) {
                    [hud hide:YES];
                    
                    NSString *msg = nil;
                    if (data) {
                        msg = [data objectForKey:@"msg"];
                    }else{
                        msg = MsgFromError(error);
                    }
                    
                    [MBProgressHUD showTextHUDAddedTo:weakSelf.view withText:msg animated:YES completionBlock:^{
                        // todo
                        if ([[data objectForKey:@"code"]isEqualToString:@"000000"]) {
                            weakSelf.status = BindStatus_vcode;
                            self.nextBarButton.title = @"完成";
                        }
                    }];
                    
                }];
            }
            break;
        }
        case BindStatus_vcode:
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            WEAKSELF(weakSelf);
            /*
            [ProfileDataManager bindPhone:self.inputTextField.text result:^(id data, NSError *error) {
                [hud hide:YES];
                
                NSString *msg = nil;
                if (data) {
                    msg = data;
                }else{
                    msg = MsgFromError(error);
                }
                
                [MBProgressHUD showTextHUDAddedTo:weakSelf.view withText:msg animated:YES completionBlock:^{
                    // todo
//                    if (data) {
//                        weakSelf.status = BindStatus_vcode;
//                    }
                }];
                
            }];
            */
            [ProfileDataManager bindPhone:self.phoneNum Vcdoe:self.inputTextField.text result:^(id data, NSError *error) {
                [hud hide:YES];
                
                NSString *msg = nil;
                if (data) {
                    msg = data;
                }else{
                    msg = MsgFromError(error);
                }
                
                [MBProgressHUD showTextHUDAddedTo:weakSelf.view withText:msg animated:YES completionBlock:^{
                }];
            }];
        }
            break;
        
        default:
            break;
    }
    
}


- (void)setStatus:(BindStatus)status
{
    _status = status;
    if (status == BindStatus_vcode) {
        self.titleLabel.text = @"验证码";
        self.inputTextField.text = nil;
        self.inputTextField.placeholder = @"请输入收到的验证码";
        
        
        self.leftTime = 60;
        [self updateButtonTitle];
        [self.actionButton setBackgroundColor:[UIColor grayColor]];
        self.actionButton.enabled  = NO;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        
        self.nextBarButton.enabled = YES;
        
    }else if(self.status == BindStatus_try){
        [self.actionButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        self.actionButton.enabled = YES;
        [self.actionButton setBackgroundColor:SS_RGBColor(0x7f,0x7f,0x7f)];
        self.nextBarButton.enabled = NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self send:nil];
    return YES;
}

#pragma mark - private

- (void)timerFire:(id)data
{
    self.leftTime --;
    if (self.leftTime < 0) {
        [self.timer invalidate];
        self.status = BindStatus_try;
    }else{
        [self updateButtonTitle];
    }
}

- (void)updateButtonTitle
{
    [self.actionButton setTitle:[self buttonTitle:self.leftTime] forState:UIControlStateNormal];
}

- (NSString *)buttonTitle:(NSInteger)time
{
    return [NSString stringWithFormat:@"重新获取验证码(%ld)", (long)time];
}

@end
