//
//  ProDataManager.h
//  Discount
//
//  Created by bilsonzhou on 15/3/24.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ModelBase.h"
#import "MsgItemInfo.h"
#import "CouponDetail.h"

@class MessageAndCoupon;
@class CouponDetail;

@interface ProDataManager : ModelBase

+ (void)parseDic:(NSDictionary *)dicData ToProItemInfo:(ItemBaseInfo *)item;
//
+ (NSArray *)itemInfoForType:(OpertationItemType)type
                        From:(ItemBaseInfo *)startItem
                          op:(OpertationType)opType
                       count:(NSInteger)count
                      result:(resultBlock)result;

+ (CouponDetail *)coupDetailForType:(OpertationItemType)type
                         byCouponID:(NSNumber *)couponID
                             result:(resultBlock)result;

+ (MessageAndCoupon *)messageCouponCountResult:(resultBlock)result;

@end
