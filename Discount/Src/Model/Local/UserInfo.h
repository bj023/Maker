//
//  UserInfo.h
//  Discount
//
//  Created by fengfeng on 15/3/29.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * isLogin;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * scope;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSData * cookie;

@end
