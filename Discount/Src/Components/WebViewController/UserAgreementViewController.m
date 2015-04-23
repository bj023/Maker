//
//  UserAgreementViewController.m
//  Discount
//
//  Created by jackyzeng on 3/29/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithURLString:kUserAgreementURLString toolbarItems:nil]) {
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithURLString:kUserAgreementURLString toolbarItems:nil]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户协议";
}

// override onCustomBackItemClicked
- (void)onCustomBackItemClicked:(id)sender {
    if ([self.navigationController viewControllers].count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
