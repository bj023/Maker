//
//  ShopHomeHeaderCell.h
//  Discount
//
//  Created by jackyzeng on 3/8/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeShareControl.h"
#import "LikeButton.h"

@interface ShopHomeHeaderCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *headerImageView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *locationLabel;
@property(nonatomic, strong) IBOutlet UIButton *infoButton;
@property(nonatomic, strong) IBOutlet LikeButton *likeButton;

@property(nonatomic, weak) UIViewController *vc;

@property(nonatomic, getter=isLiked) BOOL liked;
@property(nonatomic, retain) NSNumber *shopID;
@end
