//
//  HomeDataManager.h
//  Discount
//
//  Created by fengfeng on 15/3/9.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"
#import "HomeRecommend.h"
#import "HomeNewProduct.h"
#import "HomeDiscount.h"

@interface HomeDataManager : ModelBase

+ (NSArray *)recommendItemFrom:(HomeRecommend *)startRecommend
                         count:(NSInteger)count
                        result:(resultBlock)result;

+ (NSArray *)disCountItemFrom:(HomeDiscount *)startDiscount
                        count:(NSInteger)count
                       result:(resultBlock)result;

+ (NSArray *)newProductItemFrom:(HomeNewProduct *)startNewProduct
                          count:(NSInteger)count
                         result:(resultBlock)result;

+ (void)likeWithItem:(ItemBaseInfo *)item
              result:(resultBlock)result;

#pragma -mark 加载喜欢 状态 （攻略）
+ (void)likeStateWithItem:(NSInteger)itemType
                   ItemID:(NSNumber *)itemId
                   result:(resultBlock)result;


// 领取 优惠券
+ (void)receiveAdiscountWithItem:(NSNumber *)itemID
                          result:(resultBlock)result;

+ (void)getReceiveAdiscountWithItem:(NSNumber *)itemID
                             result:(resultBlock)result;
@end
