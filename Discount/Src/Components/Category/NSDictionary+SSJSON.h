//
//  NSDictionary+SSJSON.h
//  StarShow
//
//  Created by fengfeng on 15/1/24.
//  Copyright (c) 2015年 starshow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SSJSON)
- (NSNumber*)numberForKey:(id)aKey;

- (NSString*)stringForKey:(id)aKey;

- (NSArray *)arrayForKey:(id)aKey;

- (NSDictionary *)dictionaryForKey:(id)aKey;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
