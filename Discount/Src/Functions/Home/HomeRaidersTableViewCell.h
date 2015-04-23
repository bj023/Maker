//
//  HomeRaidersTableViewCell.h
//  Discount
//
//  Created by fengfeng on 15/3/18.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBRaidersView.h"
#import "IBShopLocationView.h"
#import "LikeButton.h"

@interface HomeRaidersTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet IBRaidersView *raidersView;
@property(nonatomic, strong) IBOutlet IBShopLocationView *locationView;

@property (weak, nonatomic, readonly) UIImageView *raidersImageView;
@property (weak, nonatomic, readonly) UILabel *contentLabel;
@property (weak, nonatomic, readonly) LikeButton *likeButton;
@property (weak, nonatomic, readonly) UILabel *address;
@property (weak, nonatomic, readonly) UIShopNameButton *shopName;

@end
