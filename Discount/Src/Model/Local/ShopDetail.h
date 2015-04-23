//
//  ShopDetail.h
//  Discount
//
//  Created by fengfeng on 15/3/22.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShopDetail : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * addr;
@property (nonatomic, retain) NSString * coords;
@property (nonatomic, retain) NSString * way;
@property (nonatomic, retain) NSString * payment;
@property (nonatomic, retain) NSString * shopHours;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSNumber * shopID;
@property (nonatomic, retain) NSString * others;

@end
