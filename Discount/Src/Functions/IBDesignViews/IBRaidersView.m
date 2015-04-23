//
//  IBRaidersView.m
//  Discount
//
//  Created by jackyzeng on 3/19/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBRaidersView.h"

@implementation IBRaidersView

- (void)setLiked:(BOOL)liked {
    _liked = liked;
    
    NSString *imageName = _liked ? @"common_liked_40pt" : @"common_like_40pt";
    [self.likeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

//- (IBAction)likeButtonPressed:(id)sender {
//    self.liked = !self.isLiked;
//}
@end
