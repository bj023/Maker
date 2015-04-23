//
//  ShopTableViewCell.h
//  Discount
//
//  Created by bilsonzhou on 15/3/25.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"

@interface ShopTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *logImgView;

@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *region;
//@property (strong, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet LikeButton *likeButton;

@end
