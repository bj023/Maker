//
//  MBProgressHUD+Helper.m
//  Discount
//
//  Created by fengfeng on 15/3/27.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "MBProgressHUD+Helper.h"

@implementation MBProgressHUD (Helper)

+ (MB_INSTANCETYPE)showTextHUDAddedTo:(UIView *)view withText:(NSString *)text animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:TOAST_SHOW_TIME];
    
    return hud;
}

+ (MB_INSTANCETYPE)showTextHUDAddedTo:(UIView *)view
                             withText:(NSString *)text
                             animated:(BOOL)animated
                      completionBlock:(MBProgressHUDCompletionBlock)block
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:TOAST_SHOW_TIME];
    hud.completionBlock = block;
    return hud;
}

@end
