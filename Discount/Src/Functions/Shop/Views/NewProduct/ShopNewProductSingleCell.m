//
//  ShopNewProductSingleCell.m
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopNewProductSingleCell.h"
#import "ItemBaseInfo.h"
#import "UserInfo.h"
#import "ProfileDataManager.h"
#import "UIViewController+loginHelper.h"
#import "HomeDataManager.h"

@implementation ShopNewProductSingleCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLiked:(BOOL)liked {
    _liked = liked;
    
    if (_liked) {
        [self.likeButton setImage:[UIImage imageNamed:@"common_liked_40pt"] forState:UIControlStateNormal];
    }
    else {
        [self.likeButton setImage:[UIImage imageNamed:@"common_like_40pt"] forState:UIControlStateNormal];
    }
}

- (IBAction)onLikeButtonPressed:(id)sender {
    ItemBaseInfo* item = (ItemBaseInfo*)self.item;
    
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    
    if (!userInfo.isLogin) {
        [self.vc showLoginViewController];
        return;
    }
    item.type = @(3);
    [HomeDataManager likeWithItem:item result:^(id data, NSError *error) {
        if (data) {
            item.favorite = @(![item.favorite boolValue]);
            self.liked = !self.liked;
        }
    }];
    
}

@end
