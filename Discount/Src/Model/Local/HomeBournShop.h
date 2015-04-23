//
//  HomeBournShop.h
//  Discount
//
//  Created by jackyzeng on 3/22/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemBaseInfo.h"

@class HomeBournRegion;

@interface HomeBournShop : ItemBaseInfo

@property (nonatomic, retain) HomeBournRegion *bournRegion;

@end
