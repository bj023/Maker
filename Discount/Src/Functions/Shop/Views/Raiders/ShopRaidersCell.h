//
//  ShopRaidersCell.h
//  Discount
//
//  Created by jackyzeng on 3/8/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBRaidersView.h"

@interface ShopRaidersCell : UITableViewCell

@property(nonatomic, strong) IBOutlet IBRaidersView *raidersView;

@property(nonatomic, strong, readonly) UILabel *contentLabel;
@property(nonatomic, strong, readonly) UIImageView *raidersImageView;
@property(nonatomic, strong, readonly) UIButton *likeButton;
@property(nonatomic, getter=isLiked) BOOL liked;

@end
