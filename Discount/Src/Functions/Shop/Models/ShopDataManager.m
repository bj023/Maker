//
//  ShopDataManager.m
//  Discount
//
//  Created by fengfeng on 15/3/16.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ShopDataManager.h"
#import "ShopHomeRecommend.h"
#import "ShopInfo.h"
#import "NetAPI.h"
#import "NSDictionary+SSJSON.h"

#import "ShopBrandCategory.h"
#import "ShopBrandCategoryInfo.h"
#import "ShopBrandLetterInfo.h"
#import "HomeBournRegion.h"
#import "HomeBournShop.h"
#import "ShopDetail.h"

NSArray *SortedFloorsArray(NSDictionary *floorsDict) {
    NSArray *keys = [floorsDict allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *floor1 = (NSNumber *)obj1;
        NSNumber *floor2 = (NSNumber *)obj2;
        return [floor1 compare:floor2];
    }];
    return sortedKeys;
}

@implementation ShopDataManager

+ (NSArray *)recommendItemFrom:(ShopHomeRecommend *)startRecommend
                        shopID:(NSNumber *)shopID
                         count:(NSInteger)count
                        result:(resultBlock)result
{
    return [self itemForType:OpertationItemType_ShopRecommend shopID:shopID From:startRecommend count:count result:result];
}

+ (NSArray *)newProductItemFrom:(ShopNewProduct *)startNewProduct
                         shopID:(NSNumber *)shopID
                          count:(NSInteger)count
                         result:(resultBlock)result
{
    return [self itemForType:OpertationItemType_ShopNewProduct shopID:shopID From:startNewProduct count:count result:result];
}


+ (NSArray *)discountItemFrom:(ShopDiscount *)startDiscount
                       shopID:(NSNumber *)shopID
                        count:(NSInteger)count
                       result:(resultBlock)result
{
    return [self itemForType:OpertationItemType_ShopDiscount shopID:shopID From:startDiscount count:count result:result];
}

+ (NSArray *)raidersItemFrom:(ShopRebate*)startRebate
                     shopID:(NSNumber *)shopID
                      count:(NSInteger)count
                     result:(resultBlock)result
{
    return [self itemForType:OpertationItemType_ShopRebate shopID:shopID From:startRebate count:count result:result];
}




+ (ShopInfo *)shopInfoByShopID:(NSNumber *)shopID
                        result:(resultBlock)result
{
    ShopInfo *shopInfoRet = [ShopInfo MR_findFirstByAttribute:@"shopId" withValue:shopID];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForShopInfoByShopID:shopID success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSDictionary *shopInfoData = [weakSelf responseData:data];
                    ShopInfo *shopInfo = [ShopInfo MR_findFirstByAttribute:@"shopId" withValue:shopID inContext:localContext];
                    if (!shopInfo) {
                        shopInfo = [ShopInfo MR_createInContext:localContext];
                    }
                    
                    shopInfo.shopId = shopID;
                    shopInfo.name   = [shopInfoData stringForKey:@"name"];
                    shopInfo.region = [shopInfoData stringForKey:@"region"];
                    shopInfo.city   = [shopInfoData stringForKey:@"city"];
                    shopInfo.img    = [shopInfoData stringForKey:@"img"];
                    shopInfo.favorite = [shopInfoData numberForKey:@"favorite"];
                    
                    
                } completion:^(BOOL success, NSError *error) {
                    result([ShopInfo MR_findFirstByAttribute:@"shopId" withValue:shopID], nil);
                }];
            }else{
                result(nil, ServerError(0));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                result(nil, error);
        }];
        
        [op start];
    }
    
    return shopInfoRet;
}


+ (NewProductDetail *)newProductDetailInfoByShopID:(NSNumber *)shopID
                                            goodID:(NSNumber *)goodsID
                                            result:(resultBlock)result
{
    NSPredicate *predictate = [NSPredicate predicateWithFormat:@"shopID = %@ and goodsID = %@", shopID, goodsID];
    
    NewProductDetail *procutDetailRet = [NewProductDetail MR_findFirstWithPredicate:predictate];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForNewProductDetail:shopID goodID:goodsID  success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSDictionary *newProductDetailData = [weakSelf responseData:data];
                    NewProductDetail *newProductDetail = [NewProductDetail MR_findFirstWithPredicate:predictate inContext:localContext];
                    
                    [newProductDetail MR_deleteInContext:localContext];
                    
                    
                    newProductDetail = [NewProductDetail MR_createInContext:localContext];
                    
                    newProductDetail.shopID = shopID;
                    newProductDetail.goodsID= goodsID;
                    newProductDetail.name   = [newProductDetailData stringForKey:@"name"];
                    newProductDetail.price1 = [newProductDetailData stringForKey:@"price1"];
                    newProductDetail.price2 = [newProductDetailData stringForKey:@"price2"];
                    newProductDetail.artNo  = [newProductDetailData stringForKey:@"art_no"];
                    newProductDetail.color  = [newProductDetailData stringForKey:@"color"];
                    newProductDetail.intro  = [newProductDetailData stringForKey:@"intro"];
                    newProductDetail.isFavorite = [newProductDetailData numberForKey:@"favorite"];
                    
                    for (NSString *imgUrl in [newProductDetailData arrayForKey:@"imgs"]) {
                        NewProductImages *image = [NewProductImages MR_createInContext:localContext];
                        image.imageUrl = imgUrl;
                        image.productDetail = newProductDetail;
                    }
                    
                    
                } completion:^(BOOL success, NSError *error) {
                    result([NewProductDetail MR_findFirstWithPredicate:predictate], nil);
                }];
            }else{
                result(nil, ServerError(0));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, error);
        }];
        
        [op start];
    }
    
    
    return procutDetailRet;
}

+ (ShopBrandCategory *)shopBrandCategoryByShopID:(NSNumber *)shopID
                                          result:(resultBlock)result {
    
    ShopBrandCategory *categoryRet = [ShopBrandCategory MR_findFirstByAttribute:@"shopId" withValue:shopID];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForShopBrandCategoryByShopID:shopID success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            
            // handle success operation
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    // handle save block
                    NSDictionary *categoryData = [weakSelf responseData:data];
                    ShopBrandCategory *category = [ShopBrandCategory MR_findFirstByAttribute:@"shopId" withValue:shopID inContext:localContext];
                    
                    [category MR_deleteInContext:localContext];
                    category = [ShopBrandCategory MR_createInContext:localContext];
                    
                    category.shopId = shopID;
                    category.shopName = [categoryData stringForKey:@"shop_name"];
                    category.hasCategory = [categoryData numberForKey:@"has_category"];
                    
                    if (category.hasCategory) {
                        for (NSDictionary *categoryInfoData in [categoryData arrayForKey:@"category_list"]) {
                            ShopBrandCategoryInfo *categoryInfo = [ShopBrandCategoryInfo MR_createInContext:localContext];
                            categoryInfo.num = [categoryInfoData numberForKey:@"num"];
                            categoryInfo.categoryId = [categoryInfoData numberForKey:@"category_id"];
                            categoryInfo.categoryName = [categoryInfoData stringForKey:@"category_name"];
                            categoryInfo.inCategory = category;
                        }
                    }

                    for (NSDictionary *letterInfoData in [categoryData arrayForKey:@"brand_list"]) {
                        ShopBrandLetterInfo *letterInfo = [ShopBrandLetterInfo MR_createInContext:localContext];
                        letterInfo.brandId = [letterInfoData numberForKey:@"brand_id"];
                        letterInfo.brandName = [letterInfoData stringForKey:@"brand_name"];
                        letterInfo.inCategory = category;
                    }
                } completion:^(BOOL success, NSError *error) {
                    // save completed
                    result([ShopBrandCategory MR_findFirstByAttribute:@"shopId" withValue:shopID], nil);
                }];
            }
            else {
                result(nil, ServerError(0));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, error);
        }];
        
        [op start];
    }
    
    return categoryRet;
}

+ (ShopTaxRefund *)taxRefundByShopID:(NSNumber *)shopID
                              result:(resultBlock)result {
    ShopTaxRefund *textRefundRet = [ShopTaxRefund MR_findFirstByAttribute:@"shopId" withValue:shopID];
    
    if (result) {
        {
            WEAKSELF(weakSelf);
            AFHTTPRequestOperation *op = [NetAPI operationForTaxRefundByShopID:shopID
                                                                       success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                
                if ([weakSelf isSuccess:data]) {
                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                        NSDictionary *refundData = [weakSelf responseData:data];
                        ShopTaxRefund *refund = [ShopTaxRefund MR_findFirstByAttribute:@"shopId" withValue:shopID inContext:localContext];
                        if (!refund) {
                            refund = [ShopTaxRefund MR_createInContext:localContext];
                        }
                        refund.shopId           = shopID;
                        refund.shopName         = [refundData stringForKey:@"shop_name"];
                        refund.serviceId        = [refundData numberForKey:@"service_id"];
                        refund.locationDict     = [refundData dictionaryForKey:@"location"];
                        
                    } completion:^(BOOL success, NSError *error) {
                        result([ShopTaxRefund MR_findFirstByAttribute:@"shopId" withValue:shopID], nil);
                    }];
                }else{
                    result(nil, ServerError(0));
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                result(nil, error);
            }];
            
            [op start];
        }
    }
    
    return textRefundRet;
}


+ (HomeBourn *)bournByID:(NSNumber *)bournId result:(resultBlock)result {
    
    HomeBourn *bournRet = [HomeBourn MR_findFirstByAttribute:@"bournId" withValue:bournId];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForBournByID:bournId success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            
            // handle success operation
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    // handle save block
                    HomeBourn *bourn = [HomeBourn MR_findFirstByAttribute:@"bournId"
                                                                withValue:bournId
                                                                inContext:localContext];
                    
                    [bourn MR_deleteInContext:localContext];
                    bourn = [HomeBourn MR_createInContext:localContext];
                    
                    bourn.bournId = bournId;
                    
                    NSArray *regionsData = [weakSelf responseData:data];
                    for (NSDictionary *aRegionData in regionsData) {
                        HomeBournRegion *region = [HomeBournRegion MR_createInContext:localContext];
                        region.bourn = bourn; // relationship
                        region.region = [aRegionData stringForKey:@"region"];
                        
                        for (NSDictionary *shopData in [aRegionData arrayForKey:@"shops"]) {
                            HomeBournShop *shop = [HomeBournShop MR_createInContext:localContext];
                            shop.bournRegion = region; // relationship
                            shop.shopID     = [shopData numberForKey:@"shop_id"];
                            shop.shopName   = [shopData stringForKey:@"shop_name"];
                            shop.isDiscount = [shopData numberForKey:@"is_discount"];
                        }
                    }
                } completion:^(BOOL success, NSError *error) {
                    // save completed
                    result([HomeBourn MR_findFirstByAttribute:@"bournId" withValue:bournId], nil);
                }];
            }
            else {
                result(nil, ServerError(0));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, error);
        }];
        
        [op start];
    }
    
    return bournRet;
}

+ (ShopDetail *)shopDetailByID:(NSNumber *)shopID result:(resultBlock)result {
    
    ShopDetail *shopDetailRet = [ShopDetail MR_findFirstByAttribute:@"shopID" withValue:shopID];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForShopDetailByShopID:shopID success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            
            // handle success operation
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    // handle save block
                    ShopDetail *shopDetail = [ShopDetail MR_findFirstByAttribute:@"shopID"
                                                                withValue:shopID
                                                                inContext:localContext];
                    
                    [shopDetail MR_deleteInContext:localContext];
                    shopDetail = [ShopDetail MR_createInContext:localContext];
                    
                    shopDetail.shopID = shopID;
                    NSDictionary *shopDetailData = [weakSelf responseData:data];
                    
                    shopDetail.imageUrl = [shopDetailData stringForKey:@"img"];
                    shopDetail.name     = [shopDetailData stringForKey:@"name"];
                    shopDetail.region   = [shopDetailData stringForKey:@"region"];
                    shopDetail.city     = [shopDetailData stringForKey:@"city"];
                    shopDetail.intro    = [shopDetailData stringForKey:@"intro"];
                    shopDetail.coords   = [shopDetailData stringForKey:@"coords"];
                    shopDetail.addr     = [shopDetailData stringForKey:@"addr"];
                    shopDetail.way      = [shopDetailData stringForKey:@"way"];
                    shopDetail.payment  = [shopDetailData stringForKey:@"payment"];
                    shopDetail.tel      = [shopDetailData stringForKey:@"tel"];
                    shopDetail.website  = [shopDetailData stringForKey:@"website"];
                    shopDetail.others   = [shopDetailData stringForKey:@"others"];
                    
                    
                } completion:^(BOOL success, NSError *error) {
                    // save completed
                    result([ShopDetail MR_findFirstByAttribute:@"shopID" withValue:shopID], nil);
                }];
            }
            else {
                result(nil, ServerError(0));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, error);
        }];
        
        [op start];
    }
    
    return shopDetailRet;
}



+ (BrandDetail *)brandDetailByShopID:(NSNumber *)shopID
                             brandID:(NSNumber *)brandID
                              result:(resultBlock)result
{
    NSPredicate *predictate = [NSPredicate predicateWithFormat:@"shopID = %@ and brandID = %@", shopID, brandID];
    BrandDetail *brandDetailRet = [BrandDetail MR_findFirstWithPredicate:predictate];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForBrandDetailByShopID:shopID brandID:brandID success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
            
            // handle success operation
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    // handle save block
                    BrandDetail *brandDetail = [BrandDetail MR_findFirstWithPredicate:predictate inContext:localContext];
                    
                    if (!brandDetail) {
                        brandDetail = [BrandDetail MR_createInContext:localContext];
                    }
                    
                    NSDictionary *brandDetailData = [weakSelf responseData:data];
                    brandDetail.shopID      = shopID;
                    brandDetail.brandID     = brandID;
                    brandDetail.floor       = [brandDetailData stringForKey:@"floor"];
                    brandDetail.coordsArray = [brandDetailData arrayForKey:@"coords"];
                    brandDetail.imgUrl      = [brandDetailData stringForKey:@"img"];
                    brandDetail.logoUrl     = [brandDetailData stringForKey:@"logo"];
                    brandDetail.intro       = [brandDetailData stringForKey:@"intro"];
                    
                } completion:^(BOOL success, NSError *error) {
                    // save completed
                    result([BrandDetail MR_findFirstByAttribute:@"brandID" withValue:brandID], nil);
                }];
            }
            else {
                result(nil, ServerError(0));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, error);
        }];
        
        [op start];
    }
    
    return brandDetailRet;
}

+ (LocateBrand *)locateBrandByShopID:(NSNumber *)shopID
                             brandID:(NSNumber *)brandID
                               floor:(NSString *)floor
                              result:(resultBlock)result {
    NSPredicate *predictate = nil;
    if (floor == nil || floor.length == 0) {
        [NSPredicate predicateWithFormat:@"shopID = %@ and brandID = %@", shopID, brandID];
    }
    else {
        predictate = [NSPredicate predicateWithFormat:@"shopID = %@ and brandID = %@ and floor = %@", shopID, brandID, floor];
    }
    
    LocateBrand *brandRet = [LocateBrand MR_findFirstWithPredicate:predictate];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForLocateBrandWithShopID:shopID
                                                                       brandID:brandID
                                                                         floor:floor
                                                                       success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                                                                           
                                                                           SSLog(@"\n\n\n\nlocateBrand->%@\n\n\n\n",operation.responseString);
            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSDictionary *brandData = [weakSelf responseData:data];
                    if (![brandData isKindOfClass:[NSDictionary class]] || [brandData count] == 0) {
                        return;
                    }
                    
                    LocateBrand *brand = [LocateBrand MR_findFirstWithPredicate:predictate inContext:localContext];
                    if (!brand) {
                        brand = [LocateBrand MR_createInContext:localContext];
                    }
                    brand.shopID        = shopID;
                    brand.brandID       = brandID;
                    brand.shopName      = [brandData stringForKey:@"shop_name"];
                    brand.servicesArray = [brandData  arrayForKey:@"services"];
                    brand.floorsArray   = SortedFloorsArray([brandData  dictionaryForKey:@"floors"]);
                    brand.floor         = [brandData stringForKey:@"floor"];
                    brand.imgUrl        = [brandData stringForKey:@"img"];
                    brand.coordsArray   = [brandData arrayForKey:@"coords"];
                    brand.width         = [brandData numberForKey:@"width"];
                    brand.height        = [brandData numberForKey:@"height"];
                
                    NSLog(@"brand.servicesArray->%@",brand.servicesArray);

                } completion:^(BOOL success, NSError *error) {
                    result([LocateBrand MR_findFirstWithPredicate:predictate], nil);
                }];
            }else{
                result(nil, ServerError(0));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, error);
        }];
        
        [op start];
    }
    
    return brandRet;
}

+ (LocateService *)locateServiceByShopID:(NSNumber *)shopID
                               serviceID:(NSNumber *)serviceID
                                   floor:(NSString *)floor
                                  result:(resultBlock)result {
    NSPredicate *predictate = nil;
    if (floor == nil || floor.length == 0) {
        [NSPredicate predicateWithFormat:@"shopID = %@ and serviceID = %@", shopID, serviceID];
    }
    else {
        predictate = [NSPredicate predicateWithFormat:@"shopID = %@ and serviceID = %@ and floor = %@", shopID, serviceID, floor];
    }
    
    LocateService *brandRet = [LocateService MR_findFirstWithPredicate:predictate];
    
    if (result) {
        WEAKSELF(weakSelf);
        AFHTTPRequestOperation *op = [NetAPI operationForLocateServiceWithShopID:shopID
                                                                       serviceID:serviceID
                                                                           floor:floor
                                                                         success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
                                                                             
                                                                             SSLog(@"\n\n\n\nservice->%@\n\n\n\n",operation.responseString);

            if ([weakSelf isSuccess:data]) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSDictionary *brandData = [weakSelf responseData:data];
                    if (![brandData isKindOfClass:[NSDictionary class]] || [brandData count] == 0) {
                        return;
                    }
                    
                    LocateService *service = [LocateService MR_findFirstWithPredicate:predictate inContext:localContext];
                    if (!service) {
                        service = [LocateService MR_createInContext:localContext];
                    }
                    service.shopID          = shopID;
                    service.serviceID       = serviceID;
                    service.shopName        = [brandData stringForKey:@"shop_name"];
                    service.servicesArray   = [brandData  arrayForKey:@"services"];
                    service.floorsArray     = SortedFloorsArray([brandData  dictionaryForKey:@"floors"]);
                    service.floor           = [brandData stringForKey:@"floor"];
                    service.imgUrl          = [brandData stringForKey:@"img"];
                    service.coordsArray     = [brandData arrayForKey:@"coords"];
                    service.width           = [brandData numberForKey:@"width"];
                    service.height           = [brandData numberForKey:@"height"];
                    
                    NSLog(@"service.servicesArray->%@",service.servicesArray);
                    
                } completion:^(BOOL success, NSError *error) {
                    result([LocateService MR_findFirstWithPredicate:predictate], nil);
                }];
            }else{
                result(nil, ServerError(0));
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result(nil, error);
        }];
        
        [op start];
    }
    
    return brandRet;
}

@end
