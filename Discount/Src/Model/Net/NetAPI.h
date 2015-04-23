//
//  NetAPI.h
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UtilDefine.h"

#define FULL_URL(a) [self urlWithPath:a]
#define FULL_URL_WITH_TYPE(type) [self urlWithItemType:type]

typedef void(^SuccessBlock)(AFHTTPRequestOperation *operation, NSDictionary *data);
typedef void(^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

typedef enum : NSUInteger {
    OpertationItemType_HomeRecommend,
    OpertationItemType_HomeDiscount,
    OpertationItemType_HomeNewProduct,
    OpertationItemType_ShopRecommend,
    OpertationItemType_ShopNewProduct,
    OpertationItemType_ShopDiscount,
    OpertationItemType_ShopRebate,
    OpertationItemType_MsgList,
    OpertationItemType_FavShop,
    OpertationItemType_FavGood,
    OpertationItemType_FavGuid,
    OpertationItemType_Coupon,
    OpertationItemType_CouponDetail,
} OpertationItemType;

typedef enum:NSUInteger
{
    OpertationType_PullToRefresh = 1,
    OpertationType_InfiniteScroll,
}OpertationType;

@interface NetAPI : NSObject

// base info
+ (NSString *)urlWithPath:(NSString *)path;
+ (NSString *)urlWithItemType:(OpertationItemType)itemType;
+ (AFHTTPRequestOperation *)requestOperationWithUrl:(NSString *)url
                                               data:(NSDictionary *)data
                                            success:(SuccessBlock)success
                                            failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForItemType:(OpertationItemType)type
                                           start:(NSNumber *)start
                                           count:(NSNumber *)count
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForItemType:(OpertationItemType)type
                                          shopID:(NSNumber *)shopID
                                           start:(NSNumber *)start
                                           count:(NSNumber *)count
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure;


+ (AFHTTPRequestOperation *)operationForShopInfoByShopID:(NSNumber *)shopID
                                                 success:(SuccessBlock)success
                                                 failure:(FailureBlock)failure;


+ (AFHTTPRequestOperation *)operationForNewProductDetail:(NSNumber *)shopID
                                                  goodID:(NSNumber *)goodID
                                                 success:(SuccessBlock)success
                                                 failure:(FailureBlock)failure;


+ (AFHTTPRequestOperation *)operationForShopBrandCategoryByShopID:(NSNumber *)shopID
                                                          success:(SuccessBlock)success
                                                          failure:(FailureBlock)failure;

// 19.	商店-查牌-分类下的品牌列表
+ (AFHTTPRequestOperation *)operationForBrandListByShopID:(NSNumber *)shopID
                                               inCategory:(NSNumber *)categoryID
                                                    success:(SuccessBlock)success
                                                    failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForTaxRefundByShopID:(NSNumber *)shopID
                                                  success:(SuccessBlock)success
                                                  failure:(FailureBlock)failure;


+ (AFHTTPRequestOperation *)operationForBournByID:(NSNumber *)bournId
                                          success:(SuccessBlock)success
                                          failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForShopDetailByShopID:(NSNumber *)shopID
                                                   success:(SuccessBlock)success
                                                   failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForBrandDetailByShopID:(NSNumber *)shopID
                                                    brandID:(NSNumber *)brandID
                                                    success:(SuccessBlock)success
                                                    failure:(FailureBlock)failure;

// 登陆
+ (AFHTTPRequestOperation *)operationForLoginWithPhone:(NSString *)phone
                                              password:(NSString *)pass
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure;

// 注册
+ (AFHTTPRequestOperation *)operationForRegWithPhone:(NSString *)phone
                                            nickName:(NSString *)nickname
                                            password:(NSString *)pass
                                               vcode:(NSString *)vcode
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure;

// 手机校验码
+ (AFHTTPRequestOperation *)operationForVcodeWithPhone:(NSString *)phone
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure;

// 手机校验码 + 昵称
+ (AFHTTPRequestOperation *)operationForVcodeWithPhone:(NSString *)phone
                                              nickName:(NSString *)nickname
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure;


+ (AFHTTPRequestOperation *)operationForUserInfoSuccess:(SuccessBlock)success
                                                failure:(FailureBlock)failure;


+ (AFHTTPRequestOperation *)operationForItemType:(OpertationItemType)type
                                              op:(OpertationType)op
                                          itemid:(NSNumber *)itemid
                                           count:(NSNumber *)count
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure;


+ (AFHTTPRequestOperation *)operationForItemType:(OpertationItemType)type
                                        couponId:(NSNumber *)couponID
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure;


+ (AFHTTPRequestOperation *)operationForUploadAvatar:(void (^)(id <AFMultipartFormData> formData))block
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure;

// 
+ (AFHTTPRequestOperation *)operationForBindPhoneVcode:(NSString *)vcode
                                           PhoneNumber:(NSString *)phoneNum
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure;



+ (AFHTTPRequestOperation *)operationForChangePasswordOldPassword:(NSString *)oldPassword
                                                      newPassword:(NSString *)newPassword
                                                          success:(SuccessBlock)success
                                                          failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForChangeNickName:(NSString *)nickName
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure;


// 反馈
+ (AFHTTPRequestOperation *)operationForFeedbackContent:(NSString *)content
                                                  email:(NSString *)email
                                                success:(SuccessBlock)success
                                                failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForLocateBrandWithShopID:(NSNumber *)shopID
                                                      brandID:(NSNumber *)brandID
                                                        floor:(NSString *)floor
                                                      success:(SuccessBlock)success
                                                      failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForLocateServiceWithShopID:(NSNumber *)shopID
                                                      serviceID:(NSNumber *)serviceID
                                                          floor:(NSString *)floor
                                                        success:(SuccessBlock)success
                                                        failure:(FailureBlock)failure;
// 注销
+ (AFHTTPRequestOperation *)operationForLogoutSuccess:(SuccessBlock)success
                                              failure:(FailureBlock)failure;

// 性别修改
+ (AFHTTPRequestOperation *)operationForChangeGender:(NSInteger)gender
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure;

// 修改地址
+ (AFHTTPRequestOperation *)operationForChangeRegionProvince:(NSString *)province
                                                         city:(NSString *)city
                                                      success:(SuccessBlock)success
                                                      failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForLikeType:(NSInteger)type
                                          isLike:(BOOL)isLike
                                          itemID:(NSNumber *)itmeID
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure;

// 获取 喜欢状态
+ (AFHTTPRequestOperation *)operationForLikeStateType:(NSInteger)type
                                               itemID:(NSNumber *)itmeID
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForgetDetailInfoItemID:(NSNumber *)itemID
                                                    success:(SuccessBlock)success
                                                    failure:(FailureBlock)failure;

+ (AFHTTPRequestOperation *)operationForgetCouponItemID:(NSNumber *)itemID
                                                success:(SuccessBlock)success
                                                failure:(FailureBlock)failure;
//
+ (AFHTTPRequestOperation *)operationForCountOfMessageSuccess:(SuccessBlock)success
                                                      failure:(FailureBlock)failure;

// 第三方登陆
+ (AFHTTPRequestOperation *)operationForUMSocialType:(NSInteger)type
                                         AccessToken:(NSString *)accessToken
                                              UserID:(NSString *)userId
                                             Success:(SuccessBlock)success
                                             failure:(FailureBlock)failure;

@end
