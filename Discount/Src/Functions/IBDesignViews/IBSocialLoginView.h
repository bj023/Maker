//
//  IBSocialLoginView.h
//  Discount
//
//  Created by jackyzeng on 3/23/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDesignableView.h"
#import "SocialShareType.h"

@protocol SocialLoginViewDelegate;

@interface IBSocialLoginView : IBDesignableView

@property(nonatomic, weak) IBOutlet id<SocialLoginViewDelegate> delegate;

@end

@protocol SocialLoginViewDelegate <NSObject>

@optional
- (void)socialLoginView:(IBSocialLoginView *)view loginWithType:(SocialShareType)type;

@end
