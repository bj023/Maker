//
//  ProfilePassViewController.m
//  Discount
//
//  Created by fengfeng on 15/3/14.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ProfilePassViewController.h"
#import "ProfileDataManager.h"

static const NSInteger passMaxLen = 16;
static const NSInteger passMinLen = 6;

@interface ProfilePassViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;

@end

@implementation ProfilePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldPassword.delegate   = self;
    self.passwordAgain.delegate = self;
    self.password.delegate      = self;
    // Do any additional setup after loading the view.
}
- (IBAction)savePassword:(id)sender {
    NSString *errorMessage = nil;
    NSString *oldPass   = self.oldPassword.text;
    NSString *pass      = self.password.text;
    NSString *passAg    = self.passwordAgain.text;
    
    [self.view endEditing:YES];
    
    if (!oldPass.length) {
        errorMessage = @"请输入旧密码";
    }
    else if (pass.length > passMaxLen || pass.length < passMinLen) {
        errorMessage = @"请输入正确的密码长度";
    }
    else if (![passAg isEqualToString:pass]){
        errorMessage = @"两次输入的密码不一致";
    }
    
    
    if (errorMessage) {
        [MBProgressHUD showTextHUDAddedTo:self.view withText:errorMessage animated:YES];
    }else{
        WEAKSELF(weakSelf);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ProfileDataManager changePasswordOldPass:oldPass
                                      newPassword:pass
                                           result:^(id data, NSError *error){
            [hud hide:YES];
                                               
            NSString *msg = nil;
            if (data) {
                msg = data;
            }else{
                msg = MsgFromError(error);
            }
            
            [MBProgressHUD showTextHUDAddedTo:weakSelf.view withText:msg animated:YES completionBlock:^{
//                [weakSelf dismissViewControllerAnimated:YES completion:^{
//                    
//                }];
            }];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self savePassword:nil];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
