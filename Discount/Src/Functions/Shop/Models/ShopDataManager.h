//
//  ShopDataManager.h
//  Discount
//
//  Created by fengfeng on 15/3/16.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ModelBase.h"
#import "ShopHomeRecommend.h"
#import "ShopInfo.h"
#import "ShopNewProduct.h"
#import "ShopDiscount.h"
#import "NewProductDetail.h"
#import "NewProductImages.h"
#import "ShopRebate.h"
#import "ShopBrandCategory.h"
#import "ShopTaxRefund.h"
#import "ShopTaxRefund+Helper.h"
#import "HomeBourn.h"
#import "ShopDetail.h"
#import "BrandDetail.h"
#import "BrandDetail+Helper.h"
#import "LocateBase+Helper.h"
#import "LocateBrand.h"
#import "LocateService.h"

@interface ShopDataManager : ModelBase



+ (NSArray *)recommendItemFrom:(ShopHomeRecommend *)startRecommend
                        shopID:(NSNumber *)shopID
                         count:(NSInteger)count
                        result:(resultBlock)result;

+ (NSArray *)newProductItemFrom:(ShopNewProduct *)startNewProduct
                        shopID:(NSNumber *)shopID
                         count:(NSInteger)count
                        result:(resultBlock)result;

+ (NSArray *)discountItemFrom:(ShopDiscount *)startDiscount
                         shopID:(NSNumber *)shopID
                          count:(NSInteger)count
                       result:(resultBlock)result;

+ (NSArray *)raidersItemFrom:(ShopRebate*)startRebate
                       shopID:(NSNumber *)shopID
                        count:(NSInteger)count
                       result:(resultBlock)result;


+ (ShopInfo *)shopInfoByShopID:(NSNumber *)shopID
                        result:(resultBlock)result;

+ (NewProductDetail *)newProductDetailInfoByShopID:(NSNumber *)shopID
                                            goodID:(NSNumber *)goodID
                                            result:(resultBlock)result;

+ (ShopBrandCategory *)shopBrandCategoryByShopID:(NSNumber *)shopID
                                          result:(resultBlock)result;


+ (ShopTaxRefund *)taxRefundByShopID:(NSNumber *)shopID
                              result:(resultBlock)result;

+ (BrandDetail *)brandDetailByShopID:(NSNumber *)shopID
                             brandID:(NSNumber *)brandID
                              result:(resultBlock)result;

+ (HomeBourn *)bournByID:(NSNumber *)bournId
                  result:(resultBlock)result;

+ (ShopDetail *)shopDetailByID:(NSNumber *)shopID
                        result:(resultBlock)result;
//直接点击导购接口：
//点击底部购物区域，选择楼层或者区域接口：
+ (LocateBrand *)locateBrandByShopID:(NSNumber *)shopID
                             brandID:(NSNumber *)brandID
                               floor:(NSString *)floor
                              result:(resultBlock)result;
//从品牌详情页，点击位置查找接口：
//从退税详情页，点击位置查找接口：
+ (LocateService *)locateServiceByShopID:(NSNumber *)shopID
                               serviceID:(NSNumber *)serviceID
                                   floor:(NSString *)floor
                                  result:(resultBlock)result;


@end
