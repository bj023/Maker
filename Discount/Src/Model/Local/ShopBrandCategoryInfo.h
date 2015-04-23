//
//  ShopBrandCategoryInfo.h
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShopBrandCategory;

@interface ShopBrandCategoryInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) ShopBrandCategory *inCategory;

@end
