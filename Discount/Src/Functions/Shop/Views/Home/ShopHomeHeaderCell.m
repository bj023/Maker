//
//  ShopHomeHeaderCell.m
//  Discount
//
//  Created by jackyzeng on 3/8/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopHomeHeaderCell.h"
#import "ProfileDataManager.h"
#import "UserInfo.h"
#import "HomeDataManager.h"
#import "UIViewController+loginHelper.h"

@implementation ShopHomeHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonPressed:(id)sender {
    SSLog(@"LikeButton Pressed");
    
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];

    if (!userInfo.isLogin) {
        [self.vc showLoginViewController];
        return;
    }
    
    ItemBaseInfo *item = [ItemBaseInfo MR_createEntity];
    item.type = @(4);
    item.shopID = self.shopID;
    item.favorite = @(self.liked);
    
    [HomeDataManager likeWithItem:item result:^(id data, NSError *error) {
        if (data) {
            self.liked = !self.liked;
        }
    }];
    
}

- (void)setLiked:(BOOL)liked {
    _liked = liked;
    
    NSString *imageName = _liked ? @"common_liked" : @"common_like";
    [self.likeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
