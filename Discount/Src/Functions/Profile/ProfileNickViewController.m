//
//  ProfileNickViewController.m
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ProfileNickViewController.h"
#import "ProfileDataManager.h"
#import "UserInfo.h"
#import "ProfileDataManager.h"

@interface ProfileNickViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation ProfileNickViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nickNameTextField.delegate = self;
    
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    
    self.nickNameTextField.placeholder = userInfo.nickName;
    
}

- (IBAction)changeNickname:(id)sender {
    
    NSString *nickName = self.nickNameTextField.text;
    
    if (!nickName.length) {
        [MBProgressHUD showTextHUDAddedTo:self.view withText:@"昵称不能为空" animated:YES];
    }else{
        WEAKSELF(weakSelf);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ProfileDataManager changeNickname:nickName result:^(id data, NSError *error){
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
    
    
    
    
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self changeNickname:nil];
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
