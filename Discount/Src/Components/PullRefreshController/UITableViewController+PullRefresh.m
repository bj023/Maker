//
//  UITableViewController+PullRefresh.m
//  Discount
//
//  Created by fengfeng on 15/3/23.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "UITableViewController+PullRefresh.h"
#import "SVPullToRefresh.h"

#define GIF_ANIMATION_TAG 10001

@implementation UITableViewController (PullRefresh)

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
//    WEAKSELF(weakSelf);
    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf loadingGifStartAnimating];
        if (actionHandler) {
            actionHandler();
        }
        
    }];
    [self.tableView.pullToRefreshView setCustomView:[self cunstomPullRefreshView] forState:SVInfiniteScrollingStateAll];
}


- (void)stopPullAnimation
{
//    [self loadingGifStopAnimating];
    [self.tableView.pullToRefreshView stopAnimating];
}

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler
{
    [self.tableView addInfiniteScrollingWithActionHandler:actionHandler];
}

- (void)stopInfiniteScrollingAnimation
{
    [self.tableView.infiniteScrollingView stopAnimating];
}


#pragma mark - private

- (UIView *)cunstomPullRefreshView
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor whiteColor];
    
    UIImage *headerImage = [UIImage imageNamed:@"loading"];
    UIImageView *headerView = [[UIImageView alloc] initWithImage:headerImage];
    headerView.center = CGPointMake(view.center.x, headerImage.size.height/2);
    headerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:headerView];
    
    UIImage *loadingImage = [UIImage imageNamed:@"loading1"];
    UIImageView *loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - loadingImage.size.width)/2, headerImage.size.height, loadingImage.size.width, loadingImage.size.height)];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 41; i++) {
        arr[i] = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d", i+1]];
    }
    loadingImageView.animationImages = arr;
    loadingImageView.animationRepeatCount = 0;
    loadingImageView.animationDuration = 1;
    [loadingImageView startAnimating];
    loadingImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    loadingImageView.tag = GIF_ANIMATION_TAG;
    [view addSubview:loadingImageView];
    
    return view;
    
}

- (void)loadingGifStartAnimating
{
    [[self loadingGifImageView] startAnimating];
}

- (void)loadingGifStopAnimating
{
    
    [[self loadingGifImageView] stopAnimating];
}

-(UIImageView *)loadingGifImageView
{
    return (UIImageView *)[self.tableView viewWithTag:GIF_ANIMATION_TAG];
}

@end
