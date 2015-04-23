//
//  ShareDataManager.m
//  Discount
//
//  Created by jackyzeng on 4/11/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShareDataManager.h"
#import "NetAPI+Share.h"
#import "NSDictionary+SSJSON.h"

@implementation ShareDataManager

+ (ShareItem *)shareItemForType:(ShareItemType)type
                         withID:(NSNumber *)anId
                         result:(resultBlock)result {
    if (type == ShareItemTypeNone) {
        return nil;
    }
    
    BOOL success;
    ShareItemInfo itemInfo = shareItemInfoForType(type, &success);
    if (!success) {
        return nil;
    }
    NSString *idKey = [NSString stringWithCString:itemInfo.idKey
                                         encoding:NSUTF8StringEncoding];
    
    ShareItem *itemRet = [ShareItem MR_findFirstByAttribute:idKey withValue:anId];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForShareItemType:type itemID:anId success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSDictionary *itemData = [weakSelf responseData:data];
                    ShareItem *item = [ShareItem MR_findFirstByAttribute:idKey withValue:anId inContext:localContext];
                    if (!item) {
                        item = [ShareItem MR_createInContext:localContext];
                    }
                    
                    [item setValue:anId forKey:idKey];
                    item.image      = [itemData stringForKey:@"image"];
                    item.link       = [itemData stringForKey:@"link"];
                    item.title      = [itemData stringForKey:@"title"];
                    item.content    = [itemData stringForKey:@"content"];
                } completion:^(BOOL success, NSError *error) {
                    result([ShareItem MR_findFirstByAttribute:idKey withValue:anId], nil);
                }]; // saveWithBlock:completion:
            }
            else {
                result(nil, ServerError(0));
            } // [weakSelf isSuccess:data]
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, error);
        }]; // operationForShareItemType:itemID:success:failure:
        
        
        [op start];
    }
    
    return itemRet;
}

+ (ShareItem *)shareItemForGuideWithID:(NSNumber *)guideId
                                result:(resultBlock)result {
    return [self shareItemForType:ShareItemTypeGuide withID:guideId result:result];
}

+ (ShareItem *)shareItemForGoodsWithID:(NSNumber *)guideId
                                result:(resultBlock)result {
    return [self shareItemForType:ShareItemTypeGoods withID:guideId result:result];
}

+ (ShareItem *)shareItemForEventWithID:(NSNumber *)guideId
                                result:(resultBlock)result {
    return [self shareItemForType:ShareItemTypeEvent withID:guideId result:result];
}

@end
