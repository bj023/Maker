//
//  MenuCouponViewController.m
//  Discount
//
//  Created by jackyzeng on 4/13/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "MenuCouponViewController.h"
#import "UIViewController+BackItem.h"

@interface MenuCouponViewController ()

@end

@implementation MenuCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"券包";
    [self removeBackItem];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
