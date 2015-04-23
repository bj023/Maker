//
//  IBShareView.m
//  Discount
//
//  Created by jackyzeng on 3/28/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "IBShareView.h"

@implementation IBShareView

- (IBAction)shareButtonClicked:(id)sender {
    SocialShareType type = (SocialShareType)[sender tag];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:clickButtonWithType:)]) {
        [self.delegate shareView:self clickButtonWithType:type];
    }
}

@end
