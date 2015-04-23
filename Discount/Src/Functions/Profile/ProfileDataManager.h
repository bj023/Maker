//
//  ProfileDataManager.h
//  Discount
//
//  Created by fengfeng on 15/3/26.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ModelBase.h"
#import "UserInfo.h"


@interface ProfileDataManager : ModelBase

+ (UserInfo *)userInfo:(resultBlock)result;
+ (void)uploadAvatarImage:(UIImage *)image result:(resultBlock)result;
+ (void)changePasswordOldPass:(NSString *)oldPassword
                  newPassword:(NSString *)newPass
                       result:(resultBlock)result;

+ (void)changeNickname:(NSString *)nickname
                result:(resultBlock)result;

+ (void)vcodeForPhone:(NSString *)phone
               result:(resultBlock)result;

+ (void)bindPhone:(NSString *)phone
            Vcdoe:(NSString *)code
           result:(resultBlock)result;

+ (void)sendFeedback:(NSString *)content
               email:(NSString *)email
              result:(resultBlock)result;

+ (void)logutResult:(resultBlock)result;


+ (void)changeGender:(NSString *)gender
              result:(resultBlock)result;

+ (void)changeRegion:(NSString *)provice
                city:(NSString *)city
              result:(resultBlock)result;
@end
