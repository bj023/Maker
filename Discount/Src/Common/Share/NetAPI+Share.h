//
//  NetAPI+Share.h
//  Discount
//
//  Created by jackyzeng on 4/11/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "NetAPI.h"

typedef NS_ENUM(NSInteger, ShareItemType) {
    ShareItemTypeNone = 0,
    ShareItemTypeGuide = 1, // 攻略
    ShareItemTypeGoods,     // 商品
    ShareItemTypeEvent,     // 折扣
};

typedef struct ShareItemInfoStruct {
    ShareItemType type;
    char *idKey;
    char *addressKey;
} ShareItemInfo;

ShareItemInfo shareItemInfoForType(ShareItemType type, BOOL *success);

@interface NetAPI (Share)

+ (AFHTTPRequestOperation *)operationForShareItemType:(ShareItemType)type
                                               itemID:(NSNumber *)itemID
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure;

@end
