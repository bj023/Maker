//
//  LikeShareControl.m
//  Discount
//
//  Created by MacQB on 3/15/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "LikeShareControl.h"
#import "ShareItem.h"
#import "ShareSheet.h"
#import "UserInfo.h"
#import "ProfileDataManager.h"
#import "HomeDataManager.h"
#import "UIViewController+loginHelper.h"
#import <SGImageCache/SGImageCache.h>

@interface LikeShareControl ()
{
    BOOL _isSend;
}

@property(nonatomic, strong) UIImage *shareImage;

@end

@implementation LikeShareControl
- (IBAction)shareBtnPressed:(id)sender {
    [self shareButtonPressed:sender];
}

- (IBAction)shareButtonPressed:(id)sender {
    SSLog(@"ShareButton Pressed");
    
    UIImage *appIcon = [UIImage imageNamed:@"AppIcon60x60"];
    
    self.shareImage = [SGImageCache imageForURL:self.shareItem.image];
    __weak typeof(self) me = self;
    [SGImageCache getImageForURL:self.shareItem.image].then(^(UIImage *image) {
        me.shareImage = image;
    });
    
    if (!self.shareImage) {
        self.shareImage = appIcon;
    }
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    [[ShareSheet sharedInstance] shareWithContent:self.shareItem.content
                                   defaultContent:appName
                                            image:self.shareImage
                                            title:self.shareItem.title
                                              url:self.shareItem.link
                                      description:nil];
}

- (void)setType:(NSNumber *)type
{
    _type = type;
}

- (void)setItemID:(NSNumber *)itemID
{
    _itemID = itemID;
}

- (IBAction)likeButtonPressed:(id)sender {
    SSLog(@"LikeShareControl->LikeButton Pressed");
    
    UserInfo *userInfo = [ProfileDataManager userInfo:nil];
    
    if (!userInfo.isLogin) {
        [self.vc showLoginViewController];
        return;
    }
    
    ItemBaseInfo *item = [ItemBaseInfo MR_createEntity];
    item.type = self.type;
    
    
    // todo refactor 这里根据type转，里面再转回来。。。。。。。。。
    switch ([self.type intValue]) {
        case 2:{
            item.guideID = self.itemID;
            break;
        }
        case 3:{
            item.targetID = self.itemID;
            break;
        }
        case 4:{
            item.shopID = self.itemID;
            break;
        }
    }
    
    UIButton *button = (UIButton *)sender;

    
    if ([button.titleLabel.text isEqualToString:@"喜欢"]) {
        
        item.favorite = @(self.liked);
        
        if (_isSend) {
            return;
        }else
            _isSend = YES;
        
        [HomeDataManager likeWithItem:item result:^(id data, NSError *error) {
            SSLog(@"请求喜欢接口 ->%@",data);
            if (data) {
                _isSend = NO;
                self.liked = !self.liked;
            }else
                _isSend = NO;
        }];
    }else{
        SSLog(@"领取优惠券");
        
        [HomeDataManager receiveAdiscountWithItem:self.itemID result:^(id data, NSError *error) {
            SSLog(@"%@",data);
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if ([json[@"code"] isEqualToString:@"000000"]) {
                self.likeButton.enabled = YES;
                self.likeButton.userInteractionEnabled = NO;
                [self.likeButton setTitle:@"已领取优惠券" forState:UIControlStateNormal];
                [self.likeButton setImage:[UIImage imageNamed:@"discount_select"] forState:UIControlStateNormal];
                self.likeButton.backgroundColor = [UIColor whiteColor];
                [self.likeButton setTitleColor: [UIColor colorWithRed:1 green:0 blue:60/255 alpha:1] forState:UIControlStateNormal];
            }
        }];
    }    
}

- (void)setLiked:(BOOL)liked {
    _liked = liked;
    
    NSString *imageName = _liked ? @"common_liked" : @"common_like"; //YES 喜欢
    [self.likeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
