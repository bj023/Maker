//
//  ProfileDataManager.m
//  Discount
//
//  Created by fengfeng on 15/3/26.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ProfileDataManager.h"
#import "NetAPI.h"
#import "NSDictionary+SSJSON.h"
#import "XXFileHelper.h"

@implementation ProfileDataManager

+ (UserInfo *)userInfo:(resultBlock)result
{
    UserInfo *userInfoRet = [UserInfo MR_findFirst];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForUserInfoSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSDictionary *userInfoData = [weakSelf responseData:data];
                    
                    UserInfo *userInfo = [UserInfo MR_findFirstInContext:localContext];
                    if (!userInfo) {
                        userInfo = [UserInfo MR_createInContext:localContext];
                    }
                    
                    userInfo.isLogin    = @(YES);
                    userInfo.avatar     = [userInfoData stringForKey:@"avatar"];
                    userInfo.nickName   = [userInfoData stringForKey:@"nickname"];
                    userInfo.sex        = [userInfoData numberForKey:@"sex"];
                    userInfo.province   = [userInfoData stringForKey:@"province"];
                    userInfo.city       = [userInfoData stringForKey:@"city"];
                    userInfo.phone      = [userInfoData stringForKey:@"phone"];
                    userInfo.email      = [userInfoData stringForKey:@"email"];
                    
                } completion:^(BOOL success, NSError *error) {
                    result([UserInfo MR_findFirst], nil);
                }];
            }
            else {
                result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, NetErrorMsg);
        }];
        
        [op start];
        
    }
    
    return userInfoRet;
}

+ (void)uploadAvatarImage:(UIImage *)image result:(resultBlock)result;
{
    WEAKSELF(weakSelf);
    AFHTTPRequestOperation *op = [NetAPI operationForUploadAvatar:^(id<AFMultipartFormData> formData) {
        NSData *avatarData = UIImageJPEGRepresentation (image, 1.0);
        NSString *avatarPath = [weakSelf avatarImageTempPath];
        [avatarData writeToFile:avatarPath atomically:YES];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:avatarPath] name:@"upfile" error:nil];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        if ([weakSelf isSuccess:data]) {
            result(@"上传成功",nil);
        }else {
            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];    
    [op start];
}


+ (void)changePasswordOldPass:(NSString *)oldPassword newPassword:(NSString *)newPass result:(resultBlock)result;
{
    AFHTTPRequestOperation *op = [NetAPI operationForChangePasswordOldPassword:oldPassword newPassword:newPass success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        WEAKSELF(weakSelf);
        if ([weakSelf isSuccess:data]) {
            result(@"修改成功", nil);
        }
        else {
            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
    [op start];
}

+ (void)changeNickname:(NSString *)nickname
                result:(resultBlock)result
{
    AFHTTPRequestOperation *op = [NetAPI operationForChangeNickName:nickname
                                                            success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        WEAKSELF(weakSelf);
        if ([weakSelf isSuccess:data]) {
            result(@"修改成功", nil);
        }
        else {
            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
    [op start];
}

+ (void)vcodeForPhone:(NSString *)phone
               result:(resultBlock)result
{
    AFHTTPRequestOperation *op = [NetAPI operationForVcodeWithPhone:phone success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        WEAKSELF(weakSelf);
        if ([weakSelf isSuccess:data]) {
            result(@"发送成功", nil);
        }
        else {
            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
    [op start];
}

+ (void)bindPhone:(NSString *)phone Vcdoe:(NSString *)code
           result:(resultBlock)result
{
//    AFHTTPRequestOperation *op = [NetAPI operationForBindPhoneVcode:phone success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
//        WEAKSELF(weakSelf);
//        if ([weakSelf isSuccess:data]) {
//            result(@"绑定成功", nil);
//        }else {
//            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        result(nil, NetErrorMsg);
//    }];
    
    AFHTTPRequestOperation *op = [NetAPI operationForBindPhoneVcode:code PhoneNumber:phone success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        WEAKSELF(weakSelf);
        if ([weakSelf isSuccess:data]) {
            result(@"绑定成功", nil);
        }else {
            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
    [op start];
}


+ (void)sendFeedback:(NSString *)content
               email:(NSString *)email
              result:(resultBlock)result
{
    AFHTTPRequestOperation *op = [NetAPI operationForFeedbackContent:content email:email success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        WEAKSELF(weakSelf);
        if ([weakSelf isSuccess:data]) {
            result(@"发送成功", nil);
        }else {
            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
    [op start];
}

+ (void)logutResult:(resultBlock)result
{
    AFHTTPRequestOperation *op = [NetAPI operationForLogoutSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        WEAKSELF(weakSelf);
        if ([weakSelf isSuccess:data]) {
            
            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                
                UserInfo *userInfo = [UserInfo MR_findFirstInContext:localContext];
                if (userInfo) {
                    [userInfo MR_deleteInContext:localContext];
                }
            }];
            
            
            result(@"退出成功", nil);
        }else {
            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
    [op start];
}


+ (void)changeGender:(NSString *)gender
              result:(resultBlock)result
{
    NSInteger genderInt = [gender isEqual:@"男"] ? 1:2;
    AFHTTPRequestOperation *op = [NetAPI operationForChangeGender:genderInt
                                                          success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        WEAKSELF(weakSelf);
        if ([weakSelf isSuccess:data]) {
            
            result(@"修改成功", nil);
        }else {
            result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil, NetErrorMsg);
    }];
    
    [op start];
}

+ (void)changeRegion:(NSString *)provice
                city:(NSString *)city
              result:(resultBlock)result
{
    AFHTTPRequestOperation *op = [NetAPI operationForChangeRegionProvince:provice
                                                                     city:city
                                                                  success:^(AFHTTPRequestOperation *operation, NSDictionary *data)
    {
          WEAKSELF(weakSelf);
          if ([weakSelf isSuccess:data]) {
              result(@"修改成功", nil);
          }else {
              result(nil, ServerErrorMsg([weakSelf errorMessage:data]));
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          result(nil, NetErrorMsg);
      }];
    
    [op start];
}


#pragma mark - private

+ (NSString *)avatarImageTempPath
{
    return [[XXFileHelper cachesPathForSubdirectory:@"avatar"] stringByAppendingPathComponent:@"avatarTemp.png"];
}

@end
