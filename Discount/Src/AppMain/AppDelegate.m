//
//  AppDelegate.m
//  Discount
//
//  Created by jackyzeng on 3/3/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "MenuViewController.h"
#import "NetAPI.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"

#import <MAMapKit/MAMapKit.h>
#import "ZLDrawerController.h"

@interface AppDelegate () <UMSocialUIDelegate>

- (BOOL)loadUI;

@end

@implementation AppDelegate

- (BOOL)loadUI {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseTabBarController *centerController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    MenuViewController *rightController = [MenuViewController new];
    
    ZLDrawerController *drawerController = [[ZLDrawerController alloc] initWithCenterViewController:centerController rightDrawerViewController:rightController];
    drawerController.maximumRightDrawerWidth = MAXIMUM_RIGHT_DRAWER_WIDTH;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningDrawerView |
                                                  MMCloseDrawerGestureModePanningCenterView;
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMSocialData openLog:YES];
    
    [UMSocialData setAppKey:kUmengAppkey];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWeChatAppId
                            appSecret:kWeChatAppSecret
                                  url:@"http://www.umeng.com/social"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:kQQAppId
                               appKey:kQQAppSecret
                                  url:@"http://www.umeng.com/social"];
    
    
    [UMSocialQQHandler setSupportWebView:NO];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    //若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，
    //这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [UMSocialSinaHandler openSSOWithRedirectURL:kSinaWeiboRedirectUri];
    
    // CoreData 数据库初始化
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Model"];
    
    // 高德地图
    [MAMapServices sharedServices].apiKey = kAMapKey;
    
    [self loadUI];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//    return  [UMSocialSnsService handleOpenURL:url];
}


- (void)loginWithType:(SocialShareType)type
         inController:(UIViewController *)controller
           completion:(UMSocialDataServiceCompletion)completion {
    
    NSString * platformName = platformNameForSocialShareType(type);
    if (!platformName) {
        return;
    }
    
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(controller,
                                  [UMSocialControllerService defaultControllerService],
                                  YES,
                                  ^(UMSocialResponseEntity *response){
                                      SSLog(@"login response is %@",response);
                                      // 获取微博用户名、uid、token等
                                      if (response.responseCode == UMSResponseCodeSuccess) {
                                          UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                                          SSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                                      }
                                      
                                      // callback
                                      completion(response);
                                      
                                      // 这里可以获取到腾讯微博openid,Qzone的token等
                                      /*
                                       if ([platformName isEqualToString:UMShareToTencent]) {
                                       [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
                                       NSLog(@"get openid  response is %@",respose);
                                       }];
                                       }
                                       */
                                      
                                      
                                  });
}

@end
