//
//  ShopProductBriefCell.h
//  Discount
//
//  Created by MacQB on 3/15/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PriceLabel.h"

@interface ShopProductBriefCell : UITableViewCell

@property(nonatomic, strong) IBOutlet PriceLabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
