//
//  NetAPI.m
//  Discount
//
//  Created by fengfeng on 15/3/15.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "NetAPI.h"
#import <AdSupport/AdSupport.h>
#import "UserInfo.h"

@implementation NetAPI

+ (AFHTTPRequestOperation *)operationForItemType:(OpertationItemType)type
                                          shopID:(NSNumber *)shopID
                                           start:(NSNumber *)start
                                           count:(NSNumber *)count
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    start = start ? start :@(0);
    
    NSInteger op = ([start integerValue] == 0) ? 1 : 2;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"op":@(op),
                                                                                  @"itemid":start,
                                                                                  @"num":count
                                                                                  }];
    if (shopID) {
        param[@"shop_id"] = shopID;
    }
    
    // todo todo 需求修改
//    if (OpertationItemType_ShopRebate == type) {
//        param = nil;
//    }
    
    return [self requestOperationWithUrl:FULL_URL_WITH_TYPE(type)
                                    data:param
                                 success:success
                                 failure:failure];
}

+ (AFHTTPRequestOperation *)operationForItemType:(OpertationItemType)type
                                          op:(OpertationType)op
                                           itemid:(NSNumber *)itemid
                                           count:(NSNumber *)count
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"op":@(op),
                                                                                  @"itemid":itemid,
                                                                                  @"num":count
                                                                                  }];

    
    return [self requestOperationWithUrl:FULL_URL_WITH_TYPE(type)
                                    data:param
                                 success:success
                                 failure:failure];
}

+ (AFHTTPRequestOperation *)operationForItemType:(OpertationItemType)type
                                              couponId:(NSNumber *)couponID
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"coupon_id" : couponID};
    return [self requestOperationWithUrl:FULL_URL_WITH_TYPE(type)
                                    data:param
                                 success:success
                                 failure:failure];
}

+ (AFHTTPRequestOperation *)operationForItemType:(OpertationItemType)type
                                           start:(NSNumber *)start
                                           count:(NSNumber *)count
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    return [self operationForItemType:type
                               shopID:nil
                                start:start
                                count:count
                              success:success
                              failure:failure];
}


+ (AFHTTPRequestOperation *)operationForShopInfoByShopID:(NSNumber *)shopID
                                                 success:(SuccessBlock)success
                                                 failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"shop_id":shopID};
    
    return [self requestOperationWithUrl:FULL_URL(@"shop/briefInfo") data:param success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForNewProductDetail:(NSNumber *)shopID
                                                  goodID:(NSNumber *)goodID
                                                 success:(SuccessBlock)success
                                                 failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"shop_id":shopID,
                            @"goods_id":goodID};
    
    return [self requestOperationWithUrl:FULL_URL(@"goods/detail") data:param success:success failure:failure];
    
}


+ (AFHTTPRequestOperation *)operationForShopBrandCategoryByShopID:(NSNumber *)shopID
                                                          success:(SuccessBlock)success
                                                          failure:(FailureBlock)failure {
    
    NSDictionary *param = @{@"shop_id":shopID};
    
    return [self requestOperationWithUrl:FULL_URL(@"brand/category") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForBrandListByShopID:(NSNumber *)shopID
                                               inCategory:(NSNumber *)categoryID
                                                  success:(SuccessBlock)success
                                                  failure:(FailureBlock)failure {
    NSDictionary *param = @{@"shop_id":shopID, @"category_id":categoryID};
    
    return [self requestOperationWithUrl:FULL_URL(@"brand/listInCategory") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForTaxRefundByShopID:(NSNumber *)shopID
                                                  success:(SuccessBlock)success
                                                  failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"shop_id":shopID};
    
    return [self requestOperationWithUrl:FULL_URL(@"shop/taxRefund") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForBournByID:(NSNumber *)bournId
                                          success:(SuccessBlock)success
                                          failure:(FailureBlock)failure {
    
    NSDictionary *param = @{@"bourn_id":bournId};
    
    NSString *urlSuffix = [NSString stringWithFormat:@"home/bourn"];
    return [self requestOperationWithUrl:FULL_URL(urlSuffix) data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForShopDetailByShopID:(NSNumber *)shopID
                                                   success:(SuccessBlock)success
                                                   failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"shop_id":shopID};
    return [self requestOperationWithUrl:FULL_URL(@"shop/detail") data:param success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForBrandDetailByShopID:(NSNumber *)shopID
                                                     brandID:(NSNumber *)brandID
                                                    success:(SuccessBlock)success
                                                    failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"shop_id":shopID,
                            @"brand_id":brandID};
    return [self requestOperationWithUrl:FULL_URL(@"brand/detail") data:param success:success failure:failure];
}

#pragma mark - 登录&注册

// 登陆
+ (AFHTTPRequestOperation *)operationForLoginWithPhone:(NSString *)phone
                                              password:(NSString *)pass
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure {
    NSDictionary *param = @{@"phone":phone, @"password":pass};
    return [self requestOperationWithUrl:FULL_URL(@"passport/phoneLogin") data:param success:success failure:failure];
}

// 注册
+ (AFHTTPRequestOperation *)operationForRegWithPhone:(NSString *)phone
                                            nickName:(NSString *)nickname
                                            password:(NSString *)pass
                                               vcode:(NSString *)vcode
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure {
    NSDictionary *param = @{@"phone":phone, @"nickname":nickname, @"password":pass, @"vcode":vcode};
    return [self requestOperationWithUrl:FULL_URL(@"passport/phoneReg") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForVcodeWithPhone:(NSString *)phone
                                              nickName:(NSString *)nickname
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"phone":phone, @"nickname":nickname};
    return [self requestOperationWithUrl:FULL_URL(@"passport/phoneRegCheck") data:param success:success failure:failure];
}

// 手机校验码
+ (AFHTTPRequestOperation *)operationForVcodeWithPhone:(NSString *)phone
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure {
    NSDictionary *param = @{@"phone":phone};
    return [self requestOperationWithUrl:FULL_URL(@"passport/getPhoneRegVcode") data:param success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForUserInfoSuccess:(SuccessBlock)success
                                                failure:(FailureBlock)failure
{
    NSDictionary *param = @{};
    return [self requestOperationWithUrl:FULL_URL(@"user/getInfo") data:param success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForUploadAvatar2:(UIImage *)avatarImage
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure

{
//    NSDictionary *param = @{@"upfile":[UIImageJPEGRepresentation (avatarImage, 1.0) base64EncodedDataWithOptions:0]};
    NSDictionary *param = @{@"upfile":@"xxxxxxx"};
    return [self requestOperationWithUrl:FULL_URL(@"user/uploadAvatar") requetMethod:@"POST" data:param useCache:NO constructingBodyWithBlock:nil success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForUploadAvatar:(void (^)(id <AFMultipartFormData> formData))block
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure

{
//    NSDictionary *param = @{@"upfile":[UIImageJPEGRepresentation (avatarImage, 1.0) base64EncodedDataWithOptions:0]};
    NSDictionary *param = @{};
    return [self requestOperationWithUrl:FULL_URL(@"user/uploadAvatar") requetMethod:@"POST" data:param useCache:NO constructingBodyWithBlock:block success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForBindPhoneVcode:(NSString *)vcode
                                           PhoneNumber:(NSString *)phoneNum
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"phone":phoneNum,@"vcode":vcode};
    return [self requestOperationWithUrl:FULL_URL(@"passport/bindPhone") data:param success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForChangePasswordOldPassword:(NSString *)oldPassword
                                                      newPassword:(NSString *)newPassword
                                                          success:(SuccessBlock)success
                                                          failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"old_password":oldPassword,
                            @"new_password":newPassword};
    return [self requestOperationWithUrl:FULL_URL(@"passport/changePassword") data:param success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForChangeNickName:(NSString *)nickName
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"nickname":nickName};
    return [self requestOperationWithUrl:FULL_URL(@"user/changeNickname") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForFeedbackContent:(NSString *)content
                                                  email:(NSString *)email
                                                success:(SuccessBlock)success
                                                failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"content":content,
                            @"email":email};
    return [self requestOperationWithUrl:FULL_URL(@"user/suggest") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForLocateBrandWithShopID:(NSNumber *)shopID
                                                      brandID:(NSNumber *)brandID
                                                        floor:(NSString *)floor
                                                      success:(SuccessBlock)success
                                                      failure:(FailureBlock)failure {
    NSDictionary *param =  nil;
    if ((floor == nil || floor.length == 0) && brandID == nil) {
        param =   @{@"shop_id":shopID};
    }
    else {
        param =   @{@"shop_id":shopID, @"brand_id":brandID, @"floor":floor};
    }

    SSLog(@"%@",param);
    
    return [self requestOperationWithUrl:FULL_URL(@"locate/brand") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForLocateServiceWithShopID:(NSNumber *)shopID
                                                      serviceID:(NSNumber *)serviceID
                                                          floor:(NSString *)floor
                                                        success:(SuccessBlock)success
                                                        failure:(FailureBlock)failure {
    
    NSDictionary *param =  nil;
    if (serviceID == nil && floor == nil) {
        param =   @{@"shop_id":shopID};
    }else if (serviceID == nil){
        param =   @{@"shop_id":shopID, @"floor":floor};
    }
    else {
        param =   @{@"shop_id":shopID, @"service_id":serviceID, @"floor" : floor};
    }
    SSLog(@"%@",param);

    return [self requestOperationWithUrl:FULL_URL(@"locate/service") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForLogoutSuccess:(SuccessBlock)success
                                              failure:(FailureBlock)failure
{
    NSDictionary *param = @{};
    return [self requestOperationWithUrl:FULL_URL(@"passport/logout") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForChangeGender:(NSInteger)gender
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"gender":@(gender)};
    return [self requestOperationWithUrl:FULL_URL(@"user/setGender") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForChangeRegionProvince:(NSString *)province
                                                         city:(NSString *)city
                                                      success:(SuccessBlock)success
                                                      failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"province":province,
                            @"city":city};
    return [self requestOperationWithUrl:FULL_URL(@"user/setRegion") data:param success:success failure:failure];
}


+ (AFHTTPRequestOperation *)operationForLikeType:(NSInteger)type
                                          isLike:(BOOL)isLike
                                          itemID:(NSNumber *)itmeID
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    NSDictionary *param = nil;
    NSString *url = nil;
    switch (type) {
        case 4:
            param = @{@"shop_id":itmeID};
            if (isLike) {
                url = FULL_URL(@"shop/favorite");
            }else{
                url = FULL_URL(@"shop/unfavorite");
            }
            
            break;
        case 3:
            param = @{@"item_id" : itmeID};
            if (isLike) {
                url = FULL_URL(@"goods/favorite");
            }else{
                url = FULL_URL(@"goods/unfavorite");
            }
            break;
        case 2:
            param = @{@"guide_id" : itmeID};
            if (isLike) {
                url = FULL_URL(@"guide/favorite");
            }else{
                url = FULL_URL(@"guide/unfavorite");
            }
            break;
        default:
            break;
    }
    
    return [self requestOperationWithUrl:url data:param success:success failure:failure];
}
#pragma -mark 获取 喜欢状态
+ (AFHTTPRequestOperation *)operationForLikeStateType:(NSInteger)type
                                               itemID:(NSNumber *)itmeID
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure
{
    NSDictionary *param = nil;

    NSString *url = nil;
    switch (type) {

        case 2:
            param = @{@"item_id" : itmeID};
            url = FULL_URL(@"guide/getDetailInfo");
            break;
        case 3:
            param = @{@"item_id" : itmeID};
            url = FULL_URL(@"goods/getDetailInfo");
            break;
        default:
            break;
    }
    
    SSLog(@"喜欢状态%@->%ld",itmeID,type);
    return [self requestOperationWithUrl:url data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForgetDetailInfoItemID:(NSNumber *)itemID
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"item_id":itemID};//@"shop_id":shopID
    SSLog(@"传递参数->%@",param);
    
    return [self requestOperationWithUrl:FULL_URL(@"event/getDetailInfo") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForgetCouponItemID:(NSNumber *)itemID
                                                success:(SuccessBlock)success
                                                failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"item_id":itemID};//@"shop_id":shopID
    SSLog(@"传递参数->%@",param);
    
    return [self requestOperationWithUrl:FULL_URL(@"event/coupon") data:param success:success failure:failure];
}

+ (AFHTTPRequestOperation *)operationForCountOfMessageSuccess:(SuccessBlock)success
                                                      failure:(FailureBlock)failure
{
    NSDictionary *param = @{};
    return [self requestOperationWithUrl:FULL_URL(@"user/getRemindCount") data:param success:success failure:failure];
}

// 第三方登陆
+ (AFHTTPRequestOperation *)operationForUMSocialType:(NSInteger)type
                                         AccessToken:(NSString *)accessToken
                                              UserID:(NSString *)userId
                                             Success:(SuccessBlock)success
                                             failure:(FailureBlock)failure
{
    NSDictionary *param;
    NSString *url = nil;
    switch (type) {
        case 1:
            url = @"passport/wxLogin";
            param = @{@"access_token":accessToken,@"openid":userId};
            break;
        case 2:
        {
            url = @"passport/wbLogin";
            param = @{@"access_token":accessToken,@"wb_id":userId};
        }
            break;
        case 3:
            url = @"passport/qqLogin";
            param = @{@"openkey":accessToken,@"openid":userId};
            break;
            
        default:
            break;
    }
    SSLog(@"%@",FULL_URL(url));
    SSLog(@"%@",param);

    return [self requestOperationWithUrl:FULL_URL(url) data:param success:success failure:failure];
}

#pragma mark - private

+ (AFHTTPRequestOperation *)requestOperationWithUrl:(NSString *)url data:(NSDictionary *)data success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [self requestOperationWithUrl:url requetMethod:@"GET" data:data useCache:NO constructingBodyWithBlock:nil success:success failure:failure];
}

+ (AFHTTPRequestOperation *)requestOperationWithUrl:(NSString *)url requetMethod:(NSString *)method data:(NSDictionary *)data  useCache:(BOOL)useCache constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    
    NSMutableDictionary *paramData = [self addBaseParamToParam:data];
    
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = nil;
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:paramData constructingBodyWithBlock:block error:nil];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:url parameters:paramData error:nil];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // cookie
//    UserInfo *userInfo = [UserInfo MR_findFirst];
//    if ([userInfo.isLogin boolValue]) {
//        if(userInfo.cookie.length){
//            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: userInfo.cookie];
//            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            
//            for (NSHTTPCookie *cookie in cookies){
//                [cookieStorage setCookie: cookie];
//            }
//        }
//    }
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SSLog(@"operation failed = [%@] error = [%@]", operation, error);
        if (failure) {
            failure(operation, error);
        }
        
    }];
    
    return op;
}

+ (NSString *)urlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@", MAIN_URL, path];
}

+ (NSString *)urlWithItemType:(OpertationItemType)itemType
{
    switch (itemType) {
        case OpertationItemType_HomeRecommend:
            return FULL_URL(@"home/recommend");
        case OpertationItemType_HomeDiscount:
            return FULL_URL(@"home/discount");
        case OpertationItemType_HomeNewProduct:
            return FULL_URL(@"home/newgoods");
        case OpertationItemType_ShopRecommend:
            return FULL_URL(@"shop/home");
        case OpertationItemType_ShopDiscount:
            return FULL_URL(@"event/list");
        case OpertationItemType_ShopNewProduct:
            return FULL_URL(@"goods/list");
        case OpertationItemType_ShopRebate:
            return FULL_URL(@"guide/list");
        case OpertationItemType_MsgList:
            return FULL_URL(@"message/list");
        case OpertationItemType_FavGood:
            return FULL_URL(@"favorite/goods");
        case OpertationItemType_FavShop:
            return FULL_URL(@"favorite/shop");
        case OpertationItemType_FavGuid:
            return FULL_URL(@"favorite/guide");
        case OpertationItemType_Coupon:
            return FULL_URL(@"coupon/myCouponList");
        case OpertationItemType_CouponDetail:
            return FULL_URL(@"coupon/detail");
        default:
            return @"";
    }
    return @"";
}


+ (NSMutableDictionary *)addBaseParamToParam:(NSDictionary *)data
{
    NSMutableDictionary *paramData = [NSMutableDictionary dictionaryWithDictionary:data];
    paramData[@"ua"] = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    paramData[@"v"]  = @"1.1";
    
    return paramData;
    
}



@end
