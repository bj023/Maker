//
//  BaseTableViewController.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ShopTableBackgroundView.h"

@interface BaseTableViewController ()

@property(nonatomic, strong) ShopTableBackgroundView *tableBackgroundView;

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearEmptyBackground];
}

- (void)loadEmptyBackgroundWithTitle:(NSString *)title image:(UIImage *)image {
    if (![self enableCustomBackground]) {
        return;
    }
    
    self.tableView.backgroundColor = [UIColor clearColor];
    if (!self.tableBackgroundView) {
        self.tableBackgroundView = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableBackgroundView" owner:nil options:nil] objectAtIndex:0];
        self.tableBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.tableView.backgroundView = self.tableBackgroundView;

    }
    
    self.tableBackgroundView.titleLabel.text = title;
    self.tableBackgroundView.imageView.image = image;
}

- (void)clearEmptyBackground {
    [self loadEmptyBackgroundWithTitle:@"" image:nil];
}

- (BOOL)enableCustomBackground {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ios8 separator
//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
