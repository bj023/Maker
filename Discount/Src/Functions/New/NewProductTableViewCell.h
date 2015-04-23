//
//  NewProductTableViewCell.h
//  Discount
//
//  Created by fengfeng on 15/3/8.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewProductInfoView.h"

#define NewProductTableViewCellIndentifier @"NewProductTableViewCellIndentifier"

@interface NewProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NewProductInfoView *left;
@property (weak, nonatomic) IBOutlet NewProductInfoView *right;

@end
