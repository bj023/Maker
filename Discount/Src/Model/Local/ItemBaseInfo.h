//
//  ItemBaseInfo.h
//  Discount
//
//  Created by fengfeng on 15/3/17.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ItemBaseInfo : NSManagedObject

@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * goodID;
@property (nonatomic, retain) NSNumber * guideID;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * isDiscount;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * price1;
@property (nonatomic, retain) NSString * price2;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSNumber * shopID;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * detail_url; // fuck 冲突了
@property (nonatomic, retain) NSNumber * targetID;

@end
