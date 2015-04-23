//
//  ShopNewProductItem.m
//  Discount
//
//  Created by jackyzeng on 3/9/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopNewProductItem.h"
#import "ItemBaseInfo.h"
#import "UserInfo.h"
#import "ProfileDataManager.h"
#import "UIViewController+loginHelper.h"
#import "HomeDataManager.h"

@implementation ShopNewProductItem

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemSelected:)]) {
        [self.delegate itemSelected:self];
    }
}

@end
