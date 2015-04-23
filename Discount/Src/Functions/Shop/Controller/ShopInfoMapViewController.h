//
//  ShopInfoMapViewController.h
//  Discount
//
//  Created by jackyzeng on 3/24/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopBaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ShopInfoMapViewController : ShopBaseViewController

@property(nonatomic) CLLocationCoordinate2D centerCoordinate;
@property(nonatomic) CGFloat zoomLevel;

- (instancetype)initWithCenterCoordinate:(CLLocationCoordinate2D)coordinate
                               zoomLevel:(CGFloat)zoomLevel;



@end
