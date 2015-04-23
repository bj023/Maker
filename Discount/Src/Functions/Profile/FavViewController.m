//
//  FavViewController.m
//  Discount
//
//  Created by bilsonzhou on 15/3/25.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "FavViewController.h"
#import "ProTableViewController.h"

@interface FavViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *HeardBarView;
@property (strong, nonatomic)ProTableViewController *proTableViewCtl;

@end

@implementation FavViewController

- (IBAction)shopButtonClicked:(id)sender {
    self.proTableViewCtl.opType = OpertationItemType_FavShop;
    [self.proTableViewCtl getInitData];
}
- (IBAction)newGoodsClicked:(id)sender {
    self.proTableViewCtl.opType = OpertationItemType_FavGood;
      [self.proTableViewCtl getInitData];
}
- (IBAction)guidClicked:(id)sender {
    self.proTableViewCtl.opType = OpertationItemType_FavGuid;
      [self.proTableViewCtl getInitData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.proTableViewCtl = [[ProTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    self.proTableViewCtl.opType = OpertationItemType_FavShop;
//    
//    CGRect frame = self.view.frame;
//    NSInteger height = self.HeardBarView.frame.origin.y + self.HeardBarView.frame.size.height;
//    frame.origin.y += height;
//    frame.size.height -= self.HeardBarView.frame.size.height;
//    [self.proTableViewCtl.tableView setFrame:frame];
//    [self addChildViewController:self.proTableViewCtl];
//    [self.view addSubview:self.proTableViewCtl.tableView];
    
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
