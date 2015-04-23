//
//  UIViewController+BackItem.m
//  Discount
//
//  Created by MacQB on 3/15/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "UIViewController+BackItem.h"

@implementation UIViewController (BackItem)

- (void)setupBackItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onCustomBackItemClicked:)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)removeBackItem {
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)onCustomBackItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
