//
//  MsgViewController.m
//  Discount
//
//  Created by bilsonzhou on 15/3/26.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "MsgViewController.h"
#import "ProTableViewController.h"

@interface MsgViewController ()

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];

    ProTableViewController *favTableViewCtl = [[ProTableViewController alloc] initWithStyle:UITableViewStylePlain];
    favTableViewCtl.opType = OpertationItemType_MsgList;
    
    CGRect frame = self.view.frame;
    [favTableViewCtl.tableView setFrame:frame];
    
    [self addChildViewController:favTableViewCtl];
    [self.view addSubview:favTableViewCtl.tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
