//
//  ShopTaxRefund+Helper.h
//  Discount
//
//  Created by jackyzeng on 4/11/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopTaxRefund.h"

@interface ShopTaxRefund (Helper)

@property (nonatomic, retain) NSDictionary * locationDict;

@property (nonatomic, readonly) NSString * img;
@property (nonatomic, readonly) NSString * fillFormIntro;
@property (nonatomic, readonly) NSString * sealIntro;
@property (nonatomic, readonly) NSArray * coordsArray;

@end
