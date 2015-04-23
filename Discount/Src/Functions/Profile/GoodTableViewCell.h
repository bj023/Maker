//
//  GoodTableViewCell.h
//  Discount
//
//  Created by bilsonzhou on 15/3/25.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"

@interface GoodTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *thumb;
@property (strong, nonatomic) IBOutlet UILabel *brand;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *region;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet LikeButton *likeButton;

@end
