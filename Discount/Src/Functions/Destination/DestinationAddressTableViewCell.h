//
//  DestinationAddressTableViewCell.h
//  Discount
//
//  Created by fengfeng on 15/3/10.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DestinationAddressTableViewCellIdentifier @"DestinationAddressTableViewCell"

@interface DestinationAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressName;
@property (weak, nonatomic) IBOutlet UIImageView *downImage;

@end
