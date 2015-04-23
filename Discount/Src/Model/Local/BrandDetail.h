//
//  BrandDetail.h
//  Discount
//
//  Created by fengfeng on 15/3/23.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BrandDetail : NSManagedObject

@property (nonatomic, retain) NSNumber * shopID;
@property (nonatomic, retain) NSString * floor;
@property (nonatomic, retain) NSData * coords;
@property (nonatomic, retain) NSString * imgUrl;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * brandID;

@end
