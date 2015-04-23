//
//  CouponTableViewCell.m
//  Discount
//
//  Created by bilsonzhou on 15/3/26.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "BarAndQrCode.h"

@interface CouponTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *qrImageView;
@property (strong, nonatomic) IBOutlet UIImageView *barImageView;

@end

@implementation CouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.qrImageView.hidden = YES;
    self.barImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"coupon_background"];
    self.statusImageView.hidden = YES;
}

- (void)setBarOrQrCodeImg:(NSString *)code withType:(NSInteger)type;
{
    UIImage *img = nil;
    if (type == 2) {
        img = [BarAndQrCode doQREncodeWithString:code size:self.qrImageView.frame.size.width];
        self.qrImageView.image = img;
        
        self.qrImageView.hidden = NO;
        self.barImageView.hidden = YES;
    }
    else
    {
        img = [BarAndQrCode doBarEncodeWithString:code size:self.barImageView.frame.size.width];
        self.barImageView.image = img;
        
        self.qrImageView.hidden = YES;
        self.barImageView.hidden = NO;
    }

}

- (void)setUsed:(BOOL)used {
    _used = used;
    
    if (_used) {
        self.statusImageView.hidden = NO;
        self.statusImageView.image = [UIImage imageNamed:@"coupon_used"];
    }
}

- (void)setExpired:(BOOL)expired {
    _expired = expired;
    
    if (_expired) {
        self.statusImageView.hidden = NO;
        self.statusImageView.image = [UIImage imageNamed:@"coupon_expired"];
        
        self.backgroundImageView.image = [UIImage imageNamed:@"coupon_backgound_expired"];
    }
    else {
        self.backgroundImageView.image = [UIImage imageNamed:@"coupon_background"];
    }
}

@end
