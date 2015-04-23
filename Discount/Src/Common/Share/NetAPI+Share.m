//
//  NetAPI+Share.m
//  Discount
//
//  Created by jackyzeng on 4/11/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "NetAPI+Share.h"

static ShareItemInfo g_ItemInfos[] = {
    {ShareItemTypeGuide,    "guide_id",     "guide"},
    {ShareItemTypeGoods,    "item_id",      "goods"},
    {ShareItemTypeEvent,    "event_id",     "event"},
};

ShareItemInfo shareItemInfoForType(ShareItemType type, BOOL *success) {
    NSInteger index;
    BOOL matchType = NO;
    ShareItemInfo itemInfo;
    for (index = 0; index < Arraysize(g_ItemInfos); index++) {
        if (type == g_ItemInfos[index].type) {
            matchType = YES;
            itemInfo = g_ItemInfos[index];
            break;
        }
    }
    if (success != NULL) {
        *success  = matchType;
    }
    
    return itemInfo;
}

@implementation NetAPI (Share)


+ (AFHTTPRequestOperation *)operationForShareItemType:(ShareItemType)type
                                               itemID:(NSNumber *)itemID
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure
{
    BOOL isSuccess;
    ShareItemInfo itemInfo = shareItemInfoForType(type, &isSuccess);
    if (!isSuccess) {
        return nil;
    }
    
    NSString *addressKey = [NSString stringWithFormat:@"%s/prepareShare", itemInfo.addressKey];
    NSString *idKey = [NSString stringWithCString:itemInfo.idKey encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{idKey:itemID};
    
    return [self requestOperationWithUrl:FULL_URL(addressKey)
                                    data:param
                                 success:success
                                 failure:failure];
}

@end
