//
//  ShareDataManager.h
//  Discount
//
//  Created by jackyzeng on 4/11/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"
#import "ShareItem.h"
#import "NetAPI+Share.h"

@interface ShareDataManager : ModelBase

+ (ShareItem *)shareItemForType:(ShareItemType)type
                         withID:(NSNumber *)anId
                         result:(resultBlock)result;
// 攻略分享
+ (ShareItem *)shareItemForGuideWithID:(NSNumber *)guideId
                                result:(resultBlock)result;

// 商品分享
+ (ShareItem *)shareItemForGoodsWithID:(NSNumber *)guideId
                                result:(resultBlock)result;

// 折扣分享
+ (ShareItem *)shareItemForEventWithID:(NSNumber *)guideId
                                result:(resultBlock)result;

@end
