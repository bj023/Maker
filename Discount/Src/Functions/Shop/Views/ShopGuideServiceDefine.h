//
//  ShopGuideServiceDefine.h
//  Discount
//
//  Created by jackyzeng on 4/4/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ShopGuideServiceType) {
    ShopGuideServiceTypeWiFi = 1,
    ShopGuideServiceTypeRestaurant,
    ShopGuideServiceTypeToilet,
    ShopGuideServiceTypeMoney,
    ShopGuideServiceTypeStop,
    ShopGuideServiceTypeRebate
};

UIImage *ServiceOnImage(ShopGuideServiceType type);
UIImage *ServiceOffImage(ShopGuideServiceType type);
UIImage *ServiceMarkImage(ShopGuideServiceType type);
