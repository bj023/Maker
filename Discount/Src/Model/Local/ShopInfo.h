//
//  ShopInfo.h
//  Discount
//
//  Created by fengfeng on 15/3/29.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShopInfo : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSNumber * shopId;
@property (nonatomic, retain) NSNumber * favorite;

@end
