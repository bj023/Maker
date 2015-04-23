//
//  ShopTaxRefund.h
//  Discount
//
//  Created by jackyzeng on 3/21/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShopTaxRefund : NSManagedObject

@property (nonatomic, retain) NSNumber * shopId;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSNumber * serviceId;
@property (nonatomic, retain) NSData * location;

@end
