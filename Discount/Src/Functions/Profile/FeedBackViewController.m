//
//  FeedBackViewController.m
//  Discount
//
//  Created by fengfeng on 15/3/28.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "FeedBackViewController.h"
#import "RPFloatingPlaceholderTextView.h"
#import "ProfileDataManager.h"

@interface FeedBackViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextView *feedBack;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@end

@implementation FeedBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackItem];
}

- (void)loadView
{
    [super loadView];    
    
    self.feedBack.placeholder = @"请在这里填写你对玩家惠的意见，我们将不断改进，感谢你的支持！";
    self.feedBack.floatingLabel.hidden = YES;
    
    self.feedBack.delegate = self;
}

- (IBAction)sendFeedback:(id)sender {
    
    NSString *errorMsg = nil;
    
    NSString *content   = self.feedBack.text;
    NSString *email     = self.emailTextField.text;
    
    if (content.length == 0) {
        errorMsg = @"请输入意见内容";
    }else if (email.length == 0){
        errorMsg = @"请输入邮箱地址";
    }
    
    if (errorMsg) {
        [MBProgressHUD showTextHUDAddedTo:self.view withText:errorMsg animated:YES];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        WEAKSELF(weakSelf);
        [ProfileDataManager sendFeedback:content
                                   email:email
                                  result:^(id data, NSError *error) {
        
            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      
            NSString *msg = nil;
            if (data) {
                msg = data;
            }else{
                msg = MsgFromError(error);
            }
            
            [MBProgressHUD showTextHUDAddedTo:weakSelf.view withText:msg animated:YES completionBlock:^{
                // todo
            }];
            
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


@end
