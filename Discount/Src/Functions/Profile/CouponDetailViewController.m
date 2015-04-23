//
//  CouponDetailViewController.m
//  Discount
//
//  Created by bilsonzhou on 15/3/27.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "ProDataManager.h"
#import "BarAndQrCode.h"
#import "UIImageView+WebCache.h"
#import "CouponDetailTableViewCotnroller.h"

@interface CouponDetailViewController ()

@property(nonatomic, strong) IBOutlet UIView *headerView;
@property(nonatomic, strong) IBOutlet UIImageView *qrImageView;
@property(nonatomic, strong) IBOutlet UIImageView *barImageView;

@property(nonatomic, strong) CouponDetailTableViewCotnroller *detailTableController;

- (void)ShowCouponDetail:(NSNumber*)couponID;

@end

@implementation CouponDetailViewController

- (instancetype)initWithCouponID:(NSNumber *)couponID {
    if (self = [super initWithNibName:@"CouponDetailViewController" bundle:nil]) {
        _couponID = couponID;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.barImageView.hidden = YES;
    self.qrImageView.hidden = YES;
    
    _detailTableController = [CouponDetailTableViewCotnroller new];
    CGRect frame = self.view.bounds;
    CGRect tableFrame = frame;
    tableFrame.origin.y += self.headerView.frame.size.height;
    tableFrame.size.height -= self.headerView.frame.size.height;

    [_detailTableController.tableView setFrame:tableFrame];
    
    [self addChildViewController:_detailTableController];
    [self.view addSubview:_detailTableController.tableView];
   
    [self ShowCouponDetail:self.couponID];
}

- (void)setCouponID:(NSNumber *)couponID {
    if (_couponID != couponID && couponID != nil) {
        _couponID = couponID;
        [self ShowCouponDetail:_couponID];
    }
    else {
        _couponID = couponID;
    }
    
}
- (void)ShowCouponDetail:(NSNumber*)couponID
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ProDataManager coupDetailForType:OpertationItemType_CouponDetail byCouponID:self.couponID result:^(id data, NSError *error){
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            CouponDetail *couponDetail = data;
            self.detailTableController.couponDetail = couponDetail;
            
            if (couponDetail.type.integerValue == 1) {
                self.barImageView.image = [BarAndQrCode doBarEncodeWithString:couponDetail.code size:self.barImageView.frame.size.width];
                self.barImageView.hidden = NO;
                self.qrImageView.hidden = YES;
            }
            else
            {
                self.qrImageView.image = [BarAndQrCode doQREncodeWithString:couponDetail.code size:self.qrImageView.frame.size.width];
                self.barImageView.hidden = YES;
                self.qrImageView.hidden = NO;
            }
        });
    }];
}

@end
