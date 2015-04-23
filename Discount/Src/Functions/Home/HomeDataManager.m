//
//  HomeDataManager.m
//  Discount
//
//  Created by fengfeng on 15/3/9.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "HomeDataManager.h"
#import "HomeRecommend.h"
#import "HomeDiscount.h"
#import "HomeNewProduct.h"
#import "NetAPI.h"

@implementation HomeDataManager


+ (void)likeWithItem:(ItemBaseInfo *)item
              result:(resultBlock)result
{
    NSInteger type = [item.type integerValue];
    NSNumber *itemID = nil;
    switch (type) {
        case 4:
            itemID = item.shopID;
            break;
        case 3:
            itemID = item.targetID;
            break;
        case 2:
            itemID = item.guideID;
            break;
        default:
            break;
    }
    
    SSLog(@"\n\n\n\n%@->%@",item.type ,itemID);
    
    WEAKSELF(weakSelf);
    
    AFHTTPRequestOperation *op = [NetAPI operationForLikeType:[item.type integerValue] isLike:![item.favorite boolValue] itemID:itemID success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        if ([weakSelf isSuccess:data]) {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                ItemBaseInfo *itemTemp = [ItemBaseInfo MR_findFirstByAttribute:@"id" withValue:item.id inContext:localContext];
                itemTemp.favorite = @(![item.favorite boolValue]);
               
            } completion:^(BOOL success, NSError *error) {
                result(@"修改成功", nil);
            }];
            
        }else{
            // 这是一个坑
            if([[weakSelf errorCode:data] integerValue] == 101001)
            {
                result(@"修改成功", nil);
            }else{
                result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
    [op start];
}


+ (NSArray *)recommendItemFrom:(HomeRecommend *)startRecommend
                         count:(NSInteger)count
                        result:(resultBlock)result
{
    
    return [self itemForType:OpertationItemType_HomeRecommend From:startRecommend count:count result:result];
}

+ (NSArray *)disCountItemFrom:(HomeDiscount *)startDiscount
                        count:(NSInteger)count
                       result:(resultBlock)result
{
    return [self itemForType:OpertationItemType_HomeDiscount From:startDiscount count:count result:result];
}

+ (NSArray *)newProductItemFrom:(HomeNewProduct *)startNewProduct
                          count:(NSInteger)count
                         result:(resultBlock)result
{
    return [self itemForType:OpertationItemType_HomeNewProduct From:startNewProduct count:count result:result];
}


+ (void)likeStateWithItem:(NSInteger)itemType
                   ItemID:(NSNumber *)itemId
                   result:(resultBlock)result
{
    
   // WEAKSELF(weakSelf);

    AFHTTPRequestOperation *op = [NetAPI operationForLikeStateType:itemType itemID:itemId success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        result(data, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
//        if ([weakSelf isSuccess:data]) {
//            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//                
//                ItemBaseInfo *itemTemp = [ItemBaseInfo MR_findFirstByAttribute:@"id" withValue:item.id inContext:localContext];
//                itemTemp.favorite = @(![item.favorite boolValue]);
//                
//            } completion:^(BOOL success, NSError *error) {
//                result(@"修改成功", nil);
//            }];
//            
//        }else{
//            // 这是一个坑
//            if([[weakSelf errorCode:data] integerValue] == 101001)
//            {
//                result(@"修改成功", nil);
//            }else{
//                result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
//            }
//        }
    
    
    [op start];
}


+ (void)receiveAdiscountWithItem:(NSNumber *)itemID
                          result:(resultBlock)result
{

    AFHTTPRequestOperation *op = [NetAPI operationForgetCouponItemID:itemID success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        SSLog(@"receiveAdiscountWithItem->%@",data);

        result(operation.responseData, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    [op start];
}

+ (void)getReceiveAdiscountWithItem:(NSNumber *)itemID
                             result:(resultBlock)result
{
    AFHTTPRequestOperation *op = [NetAPI operationForgetDetailInfoItemID:itemID success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        SSLog(@"getReceiveAdiscountWithItem->%@",data);
        result(operation.responseData, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    [op start];
}
@end
