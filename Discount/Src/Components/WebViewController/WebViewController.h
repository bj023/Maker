//
//  WebViewController.h
//  Discount
//
//  Created by jackyzeng on 3/17/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemBaseInfo.h"

@interface WebViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIWebView *webview;

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, retain) NSNumber *itemID;
@property(nonatomic, assign) NSInteger type; // type<1:折扣 2:攻略 3:新品 4:商店>
@property(nonatomic, assign) BOOL liked;
@property(nonatomic, strong) NSNumber *shopID;

- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURLString:(NSString *)urlString toolbarItems:(NSArray *)toolbarItems;

@end
