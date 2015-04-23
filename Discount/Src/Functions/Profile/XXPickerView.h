//
//  XXPickerView.h
//  Discount
//
//  Created by fengfeng on 15/3/29.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)(NSArray *selectIndex);

@interface XXPickerView : UIView

@property(nonatomic, retain) NSArray *dataSource;
@property(nonatomic, copy) completeBlock complete;


@end
