//
//  ShopGuideServiceButton.h
//  Discount
//
//  Created by jackyzeng on 4/4/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopGuideButton.h"
#import "ShopGuideServiceDefine.h"

@interface ShopGuideServiceButton : ShopGuideButton

@property(nonatomic) ShopGuideServiceType serviceType;
@property(nonatomic, strong) NSArray *serviceLocations;
@property(nonatomic, strong, readonly) UIImage *markImage;

- (instancetype)initWithServiceType:(ShopGuideServiceType)type;

@end
