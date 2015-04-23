//
//  AppDelegate.h
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialShareType.h"
#import "UMSocialDataService.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)loginWithType:(SocialShareType)type
         inController:(UIViewController *)controller
           completion:(UMSocialDataServiceCompletion)completion;

@end

