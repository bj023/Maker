//
//  DestinationTableViewCell.h
//  Discount
//
//  Created by fengfeng on 15/3/10.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DestinationTableViewCellIdentifier @"DestinationTableViewCell"

@interface DestinationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressName;

@property(nonatomic, retain) NSArray *dataSource;


@property(nonatomic, weak) UIViewController * viewController;
//@property(nonatomic, assign) BOOL 

- (void)reload;
@end
