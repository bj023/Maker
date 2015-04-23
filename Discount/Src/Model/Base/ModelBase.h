//
//  ModelBase.h
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemBaseInfo.h"
#import "NetAPI.h"

typedef void(^resultBlock)(id data, NSError *error);

#define ServerError(codeId) [NSError errorWithDomain:@"www.traveler99.com" code:codeId userInfo:nil]
#define ServerErrorMsg(msg) [NSError errorWithDomain:@"www.traveler99.com" code:0 userInfo:@{@"msg":msg?msg:@"未知错误"}]
#define MsgFromError(error) error.userInfo[@"msg"]
#define NetErrorMsg [NSError errorWithDomain:@"www.traveler99.com" code:0 userInfo:@{@"msg":@"网络错误"}]


@interface ModelBase : NSObject

+ (NSNumber *)errorCode:(NSDictionary *)result;
+ (NSString *)errorMessage:(NSDictionary *)result;
+ (id)responseData:(NSDictionary *)result;
+ (BOOL)isSuccess:(NSDictionary *)result;
+ (Class)classForItemType:(OpertationItemType)type;

+ (NSPredicate *)predicateForStart:(NSInteger )start
                          andCount:(NSInteger)count;
+ (NSArray *)NSManagedObject:(Class)manager
                   findStart:(NSInteger)start
                    andCount:(NSInteger)count;

+ (void)parseDic:(NSDictionary *)dicData
  ToItemBaseInfo:(ItemBaseInfo *)item;

+ (NSArray *)itemForType:(OpertationItemType)type
                    From:(ItemBaseInfo *)startItem
                   count:(NSInteger)count
                  result:(resultBlock)result;

+ (NSArray *)itemForType:(OpertationItemType)type
                  shopID:(NSNumber *)shopID
                    From:(ItemBaseInfo *)startItem
                   count:(NSInteger)count
                  result:(resultBlock)result;

@end
