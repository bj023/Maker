//
//  ShopGuideServiceDefine.m
//  Discount
//
//  Created by jackyzeng on 4/4/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopGuideServiceDefine.h"

#define JOIN(service, status) "guide_"#service"_"#status
#define on(service) JOIN(service, on)
#define off(service) JOIN(service, off)
#define map(service) JOIN(service, map)

typedef struct {
    ShopGuideServiceType type;
    char *onImageName;
    char *offImageName;
    char *markImageName;
} TypeImageStruct;

TypeImageStruct typeImageArray[] = {
    {ShopGuideServiceTypeWiFi,          on(wifi),        off(wifi),       map(wifi)},
    {ShopGuideServiceTypeRestaurant,    on(restaurant),  off(restaurant), map(restaurant)},
    {ShopGuideServiceTypeToilet,        on(toilet),      off(toilet),     map(toilet)},
    {ShopGuideServiceTypeMoney,         on(money),       off(money),      map(money)},
    {ShopGuideServiceTypeStop,          on(stop),        off(stop),       map(stop)},
    {ShopGuideServiceTypeRebate,        on(rebate),      off(rebate),     map(rebate)},
};

NSString *const kOnImageKey = @"onImage";
NSString *const kOffImageKey = @"offImage";
NSString *const kMarkImageKey = @"markImage";

static NSMutableDictionary *serviceTypeImageDict = nil;

void SetUpImageForType(ShopGuideServiceType type,
                       NSString *onImageName,
                       NSString *offImageName,
                       NSString *markImageName) {
    UIImage *onImage = [UIImage imageNamed:onImageName];
    UIImage *offImage = [UIImage imageNamed:offImageName];
    UIImage *markImage = [UIImage imageNamed:markImageName];
    if (onImage == nil || offImage == nil) {
        return;
    }
    NSDictionary *imageDict = nil;
    if (markImage) {
        imageDict = @{kOnImageKey:onImage, kOffImageKey:offImage, kMarkImageKey:markImage};
    }
    else {
        imageDict = @{kOnImageKey:onImage, kOffImageKey:offImage};
    }
    
    serviceTypeImageDict[@(type)] = imageDict;
}

void SetUpServiceTypeImageDictIfNeed() {
    if (!serviceTypeImageDict) {
        serviceTypeImageDict = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < Arraysize(typeImageArray); i++) {
            TypeImageStruct typeImage = typeImageArray[i];
            SetUpImageForType(typeImage.type,
                              [NSString stringWithUTF8String:typeImage.onImageName],
                              [NSString stringWithUTF8String:typeImage.offImageName],
                              [NSString stringWithUTF8String:typeImage.markImageName]);
        }
    }
}

UIImage *ImageWithTypeAndKey(ShopGuideServiceType type, NSString *key) {
    SetUpServiceTypeImageDictIfNeed();
    return serviceTypeImageDict[@(type)][key];
}

UIImage *ServiceOnImage(ShopGuideServiceType type) {
    return ImageWithTypeAndKey(type, kOnImageKey);
}

UIImage *ServiceOffImage(ShopGuideServiceType type) {
    return ImageWithTypeAndKey(type, kOffImageKey);
}

UIImage *ServiceMarkImage(ShopGuideServiceType type) {
    return ImageWithTypeAndKey(type, kMarkImageKey);
}
