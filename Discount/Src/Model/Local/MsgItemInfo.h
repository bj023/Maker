//
//  MsgItemInfo.h
//  Discount
//
//  Created by bilsonzhou on 15/3/26.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemBaseInfo.h"


@interface MsgItemInfo : ItemBaseInfo

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * typeName;

@end
