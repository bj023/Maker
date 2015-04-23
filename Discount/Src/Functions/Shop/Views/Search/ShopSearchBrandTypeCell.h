//
//  ShopSearchBrandTypeCell.h
//  Discount
//
//  Created by jackyzeng on 3/17/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShopSearchValueType) {
    ShopSearchValueTypeKind,
    ShopSearchValueTypeAlphabet,
};

@protocol ShopSearchBrandTypeCellDelegate;

@interface ShopSearchBrandTypeCell : UITableViewCell

@property(nonatomic) id<ShopSearchBrandTypeCellDelegate> delegate;
@property(nonatomic, strong) IBOutlet UIButton *kindButton;
@property(nonatomic, strong) IBOutlet UIButton *alphabetButton;
@property(nonatomic, strong) UIView *markLine;
@property(nonatomic) ShopSearchValueType currentType;

@end

@protocol ShopSearchBrandTypeCellDelegate <NSObject>

@optional
- (void)brandTypeCell:(ShopSearchBrandTypeCell *)cell selectType:(ShopSearchValueType)type;

@end
