//
//  FavGood.h
//  Discount
//
//  Created by bilsonzhou on 15/3/27.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemBaseInfo.h"


@interface FavGood : ItemBaseInfo

@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) NSString * detailUrl;

@end
