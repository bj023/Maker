//
//  ProDataManager.m
//  Discount
//
//  Created by bilsonzhou on 15/3/24.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ProDataManager.h"
#import "NSDictionary+SSJSON.h"
#import "FavGood.h"
#import "FavShop.h"
#import "FavGuid.h"
#import "Coupon.h"
#import "CouponDetail.h"
#import "MessageAndCoupon.h"

@implementation ProDataManager


+ (void)parseDic:(NSDictionary *)dicData ToProItemInfo:(ItemBaseInfo *)item
{
    item.type      = [dicData numberForKey:@"type"];
    item.title     = [dicData stringForKey:@"title"];
    item.region    = [dicData stringForKey:@"region"];
    item.city      = [dicData stringForKey:@"city"];
    item.shopName  = [dicData stringForKey:@"shop_name"];
    item.itemID    = [dicData numberForKey:@"id"];
    item.name      = [dicData stringForKey:@"name"];
    item.logoUrl   = [dicData stringForKey:@"logo"];
    item.brand     = [dicData stringForKey:@"brand"];
    item.favorite  = [dicData numberForKey:@"favorite"];
    item.detail_url = [dicData stringForKey:@"detail_url"];
    //todo
    item.favorite = @(YES);
    
    if ([item isKindOfClass:[MsgItemInfo class]]) {
        MsgItemInfo *info = (MsgItemInfo*)item;
        info.content   = [dicData stringForKey:@"content"];
        info.typeName = [dicData stringForKey:@"type_name"];
        info.targetID = [dicData numberForKey:@"target_id"];
    }
    if ([item isKindOfClass:[FavGood class]] || [item isKindOfClass:[FavGuid class]]) {
        FavGood *info = (FavGood*)item;
        info.thumb   = [dicData stringForKey:@"thumb"];
        info.targetID = [dicData numberForKey:@"target_id"];
        info.detailUrl = [dicData stringForKey:@"detail_url"];
    }
    if ([item isKindOfClass:[FavShop class]]) {
        FavShop *info = (FavShop*)item;
        info.targetID = [dicData numberForKey:@"target_id"];
    }
    if ([item isKindOfClass:[Coupon class]] || [item isKindOfClass:[CouponDetail class]]) {
        CouponDetail *detail = (CouponDetail*)item;
        detail.couponID = [dicData numberForKey:@"coupon_id"];
        detail.startDate = [dicData stringForKey:@"start_date"];
        detail.endDate = [dicData stringForKey:@"end_date"];
        detail.code = [dicData stringForKey:@"code"];
        detail.expired = [dicData numberForKey:@"expired"];
        detail.used = [dicData numberForKey:@"used"];
        if ([item isKindOfClass:[CouponDetail class]]) {
            detail.shopLogo = [dicData stringForKey:@"shop_logo"];
            detail.nameCn = [dicData stringForKey:@"name_cn"];
            detail.nameLocal = [dicData stringForKey:@"name_local"];
            detail.detailCn = [dicData stringForKey:@"detail_cn"];
            detail.detailLocal = [dicData stringForKey:@"detail_local"];
            detail.attentionCn = [dicData stringForKey:@"attention_cn"];
            detail.attentionLocal = [dicData stringForKey:@"attention_local"];
        }
    }
}



+ (NSArray *)itemInfoForType:(OpertationItemType)type
                       From:(ItemBaseInfo *)startItem
                         op:(OpertationType)opType
                      count:(NSInteger)count
                     result:(resultBlock)result
{
    NSInteger start = startItem ? startItem.id.integerValue : 0;
    NSNumber *itemID = startItem.itemID ?  startItem.itemID : @(0);
    
    NSArray *ret = [self NSManagedObject:[self classForItemType:type] findStart:start  andCount:count];
    
    if (result) {
        
        AFHTTPRequestOperation *op = [NetAPI operationForItemType:type
                                                               op:opType
                                                           itemid:itemID
                                                            count:@(count)
                                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                                                              
          if ([self isSuccess:data]) {
              [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                  
                  if (start == 0) {
                      [[self classForItemType:type] MR_truncateAllInContext:localContext];
                  }
                  
                  NSArray *items = [self responseData:data];
                  
                  NSInteger idStart = start + 1;
                  for (NSDictionary *item in items) {
                      ItemBaseInfo *baseItem = [[self classForItemType:type] MR_createInContext:localContext];
                      [self parseDic:item ToProItemInfo:baseItem];
                      baseItem.id = @(idStart++);
//                      baseItem.favorite = @()
                  }
              } completion:^(BOOL success, NSError *error) {
                  result([self NSManagedObject:[self classForItemType:type] findStart:start andCount:count], nil);
                  
              }];
              
          }else{
              result(nil, ServerError(0));
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          result(nil, error);
      }];
        
        [op start];
    }
    
    
    return ret;
}

+ (CouponDetail *)coupDetailForType:(OpertationItemType)type
                         byCouponID:(NSNumber *)couponID
                             result:(resultBlock)result
{
    
    CouponDetail *ret = [CouponDetail MR_findFirstByAttribute:@"couponID" withValue:couponID];
    if (result) {
        WEAKSELF(weakSelf);
        
        
        AFHTTPRequestOperation *op = [NetAPI operationForItemType:type
                                                         couponId:couponID
                                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                                                              
              if ([weakSelf isSuccess:data]) {
                  [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                      
                      NSDictionary *item = [weakSelf responseData:data];
                      CouponDetail *couponDetail = [[self classForItemType:type] MR_createInContext:localContext];
                      [weakSelf parseDic:item ToProItemInfo:couponDetail];
                      result(couponDetail, ServerError(0));
                  }completion:^(BOOL success, NSError *error) {
                      
                  }];
                  
                  
              }
              else
              {
                  result(nil, ServerError(0));
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              result(nil, error);
          }];
        
        [op start];
    }
    
    return ret;
}

+ (MessageAndCoupon *)messageCouponCountResult:(resultBlock)result
{
    MessageAndCoupon *ret = [MessageAndCoupon MR_findFirst];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForCountOfMessageSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSDictionary * dataDic = [weakSelf responseData:data];
                    
                    MessageAndCoupon * messageAndCoupon = [MessageAndCoupon MR_findFirstInContext:localContext];
                    if (!messageAndCoupon) {
                        messageAndCoupon = [MessageAndCoupon MR_createInContext:localContext];
                    }
                    
                    messageAndCoupon.messageCount = [dataDic numberForKey:@"message"];
                    messageAndCoupon.couponCount  = [dataDic numberForKey:@"coupon"];
                    
                } completion:^(BOOL success, NSError *error) {
                    result([MessageAndCoupon MR_findFirst], nil);
                }];
            }else{
                result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, NetErrorMsg);
        }];
        
        [op start];
    }
    
    
    return ret;
}

@end
