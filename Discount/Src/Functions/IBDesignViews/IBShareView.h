//
//  IBShareView.h
//  Discount
//
//  Created by jackyzeng on 3/28/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDesignableView.h"
#import "SocialShareType.h"

@protocol ShareViewDelegate;

@interface IBShareView : IBDesignableView

@property(nonatomic, weak) IBOutlet id<ShareViewDelegate> delegate;
@property(nonatomic, strong) IBOutlet UIButton *cancelButton;

@end

@protocol ShareViewDelegate <NSObject>

@optional
- (void)shareView:(IBShareView *)shareView clickButtonWithType:(SocialShareType)type;
- (void)shareViewDidDismiss:(IBShareView *)shareView;

@end
