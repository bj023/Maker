//
//  ShareViewController.h
//  Discount
//
//  Created by jackyzeng on 3/28/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "BaseViewController.h"

@protocol ShareViewDelegate;

@interface ShareViewController : BaseViewController

- (instancetype)initWithShareViewDelegate:(id<ShareViewDelegate>)delegate;

@end
