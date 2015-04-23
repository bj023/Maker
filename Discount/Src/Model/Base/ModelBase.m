//
//  ModelBase.m
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ModelBase.h"
#import "NSDictionary+SSJSON.h"

#import "HomeRecommend.h"
#import "HomeDiscount.h"
#import "HomeNewProduct.h"
#import "ShopHomeRecommend.h"
#import "ShopNewProduct.h"
#import "ShopDiscount.h"
#import "ShopRebate.h"
#import "MsgItemInfo.h"
#import "FavShop.h"
#import "FavGood.h"
#import "FavGuid.h"
#import "Coupon.h"
#import "CouponDetail.h"


@implementation ModelBase

+ (NSNumber *)errorCode:(NSDictionary *)result
{
    return result[@"code"];
}

+ (NSString *)errorMessage:(NSDictionary *)result
{
    return result[@"msg"];
}

+ (id)responseData:(NSDictionary *)result
{
    return result[@"data"];
}

+ (BOOL)isSuccess:(NSDictionary *)result
{
    if (result) {
        return ([[self errorCode:result] integerValue] == 0);
    }
    return NO;
}

+ (NSArray *)NSManagedObject:(Class)manager findStart:(NSInteger)start andCount:(NSInteger)count
{
    return [manager MR_findAllSortedBy:@"id" ascending:YES withPredicate:[self predicateForStart:start andCount:count]];
}

+ (NSPredicate *)predicateForStart:(NSInteger )start andCount:(NSInteger)count
{
    return [NSPredicate predicateWithFormat:@"id > %d and id < %d", start, start + count];
}

+ (void)parseDic:(NSDictionary *)dicData ToItemBaseInfo:(ItemBaseInfo *)item
{
    item.type      = [dicData numberForKey:@"type"];
    item.eventID   = [dicData numberForKey:@"event_id"];
    item.imageUrl  = [dicData stringForKey:@"img"];
    item.brand     = [dicData stringForKey:@"brand"];
    item.title     = [dicData stringForKey:@"title"];
    item.region    = [dicData stringForKey:@"region"];
    item.city      = [dicData stringForKey:@"city"];
    item.shopName  = [dicData stringForKey:@"shop_name"];
    item.shopID    = [dicData numberForKey:@"shop_id"];
    item.isDiscount= [dicData numberForKey:@"is_discount"];
    item.guideID   = [dicData numberForKey:@"guide_id"];
    item.favorite  = [dicData numberForKey:@"favorite"];
    item.goodID    = [dicData numberForKey:@"goods_id"];
    item.price1    = [dicData stringForKey:@"price1"];
    item.price2    = [dicData stringForKey:@"price2"];
    item.name      = [dicData stringForKey:@"name"];
    item.logoUrl   = [dicData stringForKey:@"logo"];
    item.itemID    = [dicData numberForKey:@"id"];
    item.detail_url = [dicData stringForKey:@"detail_url"];
    item.targetID  = [dicData numberForKey:@"target_id"];
}

+ (Class)classForItemType:(OpertationItemType)type
{
    switch (type) {
        case OpertationItemType_HomeRecommend:
            return [HomeRecommend class];
        case OpertationItemType_HomeNewProduct:
            return [HomeNewProduct class];
        case OpertationItemType_HomeDiscount:
            return [HomeDiscount class];
        case OpertationItemType_ShopNewProduct:
            return [ShopNewProduct class];
        case OpertationItemType_ShopDiscount:
            return [ShopDiscount class];
        case OpertationItemType_ShopRecommend:
            return [ShopHomeRecommend class];
        case OpertationItemType_ShopRebate:
            return [ShopRebate class];
        case OpertationItemType_MsgList:
            return [MsgItemInfo class];
        case OpertationItemType_FavShop:
            return [FavShop class];
        case OpertationItemType_FavGood:
            return [FavGood class];
        case OpertationItemType_FavGuid:
            return [FavGuid class];
        case OpertationItemType_Coupon:
            return [Coupon class];
        case OpertationItemType_CouponDetail:
            return [CouponDetail class];
        default:
            break;
    }
}

+ (NSArray *)itemForType:(OpertationItemType)type
                  shopID:(NSNumber *)shopID
                    From:(ItemBaseInfo *)startItem
                   count:(NSInteger)count
                  result:(resultBlock)result
{
    NSInteger start = startItem ? startItem.id.integerValue : 0;
    
    NSArray *ret = [self NSManagedObject:[self classForItemType:type] findStart:start andCount:count];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForItemType:type
                                                           shopID:shopID
                                                            start:startItem.itemID
                                                            count:@(count)
                                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                                                             
              if ([weakSelf isSuccess:data] && [weakSelf responseData:data]) {
                  [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                      
                      if (start == 0) {
                          [[self classForItemType:type] MR_truncateAllInContext:localContext];
                      }
                      
                      NSArray *items = [weakSelf responseData:data];
                    
                      NSInteger idStart = start + 1;
                      for (NSDictionary *item in items) {
                          ItemBaseInfo *baseItem = [[self classForItemType:type] MR_createInContext:localContext];
                          [weakSelf parseDic:item ToItemBaseInfo:baseItem];
                          baseItem.id = @(idStart++);
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

+ (NSArray *)itemForType:(OpertationItemType)type
                    From:(ItemBaseInfo *)startItem
                   count:(NSInteger)count
                  result:(resultBlock)result
{
    return [self itemForType:type shopID:nil From:startItem count:count result:result];
}

- (NSString *)priceProcess:(NSString *)price
{
    NSRange range = [price rangeOfString:@"："];
    if (range.location != NSNotFound) {
        return price;
    }
    return nil;
}

@end
