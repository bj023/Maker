//
//  LikeShareControl.h
//  Discount
//
//  Created by MacQB on 3/15/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"
#import "IBDesignableView.h"
//IB_DESIGNABLE

@class ShareItem;

@interface LikeShareControl : IBDesignableView

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property(nonatomic, strong) IBOutlet LikeButton *likeButton;
@property(nonatomic, strong) IBOutlet UIButton *shareButton;
@property(nonatomic, strong) IBOutlet UIView *topSeparator;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property(nonatomic, retain) ShareItem *shareItem;
@property(nonatomic, weak) UIViewController *vc;
@property(nonatomic, getter=isLiked) BOOL liked;
@property(nonatomic, retain) NSNumber *itemID;
@property(nonatomic, retain) NSNumber *type;

@end
