//
//  ShopTaxRefund+Helper.m
//  Discount
//
//  Created by jackyzeng on 4/11/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopTaxRefund+Helper.h"

@implementation ShopTaxRefund (Helper)

- (void)setLocationDict:(NSDictionary *)locationDict {
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:locationDict];
    self.location = dictData;
}

- (NSDictionary *)locationDict {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.location];
}

- (NSArray *)coordsArray {
    return self.locationDict[@"coords"];
}

- (NSString *)img {
    return self.locationDict[@"img"];
}

- (NSString *)sealIntro {
    return self.locationDict[@"seal_intro"];
}

- (NSString *)fillFormIntro {
    return self.locationDict[@"fill_form_intro"];
}

@end
