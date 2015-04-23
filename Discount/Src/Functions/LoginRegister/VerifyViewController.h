//
//  VerifyViewController.h
//  Discount
//
//  Created by jackyzeng on 3/23/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "BaseViewController.h"

@class RegisterViewController;

@interface VerifyViewController : BaseViewController

@property(nonatomic, strong) NSString *phoneNumber;
@property(nonatomic, strong) NSString *nikName;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, weak) RegisterViewController *registerController;

- (void)fireTimerIfNeed;
@end
