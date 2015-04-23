//
//  MBProgressHUD+Helper.h
//  Discount
//
//  Created by fengfeng on 15/3/27.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Helper)

+ (MB_INSTANCETYPE)showTextHUDAddedTo:(UIView *)view
                             withText:(NSString *)text
                             animated:(BOOL)animated;

+ (MB_INSTANCETYPE)showTextHUDAddedTo:(UIView *)view
                             withText:(NSString *)text
                             animated:(BOOL)animated
                      completionBlock:(MBProgressHUDCompletionBlock)block;
@end
