//
//  NSDictionary+SSJSON.m
//  StarShow
//
//  Created by fengfeng on 15/1/24.
//  Copyright (c) 2015年 starshow. All rights reserved.
//

#import "NSDictionary+SSJSON.h"

@implementation NSDictionary (SSJSON)

- (NSNumber*)numberForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    if (value && [value isKindOfClass:[NSString class]]) {
        return @([value integerValue]);
    }
    return [NSNumber numberWithInt:0];
}

- (NSString*)stringForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if (value && [value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}

- (NSArray *)arrayForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)dictionaryForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
