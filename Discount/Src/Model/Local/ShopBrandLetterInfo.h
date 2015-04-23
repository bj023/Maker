//
//  ShopBrandLetterInfo.h
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShopBrandCategory;

@interface ShopBrandLetterInfo : NSManagedObject

@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSNumber * brandId;
@property (nonatomic, retain) ShopBrandCategory *inCategory;

@end
