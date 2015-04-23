//
//  DestinationShopTableViewCell.h
//  Discount
//
//  Created by fengfeng on 15/3/10.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DestinationShopTableViewCellIdentifier @"DestinationShopTableViewCell"

@interface DestinationShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *shopDiscount;

@end
