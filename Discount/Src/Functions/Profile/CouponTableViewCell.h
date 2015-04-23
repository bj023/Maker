//
//  CouponTableViewCell.h
//  Discount
//
//  Created by bilsonzhou on 15/3/26.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CouponTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *codeLable;
@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property(nonatomic, getter=isUserd) BOOL used;
@property(nonatomic, getter=isExpired) BOOL expired;

- (void)setBarOrQrCodeImg:(NSString*)code withType:(NSInteger)type;
@end
