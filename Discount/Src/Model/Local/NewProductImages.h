//
//  NewProductImages.h
//  Discount
//
//  Created by fengfeng on 15/3/17.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewProductDetail;

@interface NewProductImages : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NewProductDetail *productDetail;

@end
