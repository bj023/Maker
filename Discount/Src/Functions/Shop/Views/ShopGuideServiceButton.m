//
//  ShopGuideServiceButton.m
//  Discount
//
//  Created by jackyzeng on 4/4/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopGuideServiceButton.h"

@implementation ShopGuideServiceButton

- (instancetype)initWithServiceType:(ShopGuideServiceType)type {
    if (self = [super initWithOnImage:ServiceOnImage(type)
                             offImage:ServiceOffImage(type)]) {
        
        _serviceType = type;
    }
    return self;
}

- (void)setServiceType:(ShopGuideServiceType)serviceType {
    _serviceType = serviceType;
    
    [self setOnImage:ServiceOnImage(_serviceType)
            offImage:ServiceOffImage(_serviceType)];
}

- (UIImage *)markImage {
    return ServiceMarkImage(self.serviceType);
}

@end
