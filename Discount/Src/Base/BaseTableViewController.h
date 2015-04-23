//
//  BaseTableViewController.h
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BackItem.h"

@interface BaseTableViewController : UITableViewController

- (void)clearEmptyBackground;
- (void)loadEmptyBackgroundWithTitle:(NSString *)title image:(UIImage *)image;

- (BOOL)enableCustomBackground; // Default YES.

@end
