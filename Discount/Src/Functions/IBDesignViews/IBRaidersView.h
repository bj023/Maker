//
//  IBRaidersView.h
//  Discount
//
//  Created by jackyzeng on 3/19/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBDesignableView.h"

@interface IBRaidersView : IBDesignableView

@property(nonatomic, strong) IBOutlet UILabel *contentLabel;
@property(nonatomic, strong) IBOutlet UIImageView *raidersImageView;
@property(nonatomic, strong) IBOutlet UIButton *likeButton;
@property(nonatomic, getter=isLiked) BOOL liked;

@end
