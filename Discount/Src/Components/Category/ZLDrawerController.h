//
//  ZLDrawerController.h
//  Discount
//
//  Created by jackyzeng on 4/2/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerController+Subclass.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

@class DrawerMaskView;

@interface ZLDrawerController : MMDrawerController

///---------------------------------------
/// @name Opening/Closing Drawer
///---------------------------------------
/**
 The method that handles closing the drawer. You can subclass this method to get a callback every time the drawer is about to be closed. You can inspect the current open side to determine what side is about to be closed.
 
 @param animated A boolean that indicates whether the drawer should close with animation
 @param velocity A float indicating how fast the drawer should close
 @param animationOptions A mask defining the animation options of the animation
 @param completion A completion block to be called when the drawer is finished closing
 */
-(void)closeDrawerAnimated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion __attribute((objc_requires_super));

/**
 The method that handles opening the drawer. You can subclass this method to get a callback every time the drawer is about to be opened.
 
 @param drawerSide The drawer side that will be opened
 @param animated A boolean that indicates whether the drawer should open with animation
 @param velocity A float indicating how fast the drawer should open
 @param animationOptions A mask defining the animation options of the animation
 @param completion A completion block to be called when the drawer is finished opening
 */
-(void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion __attribute((objc_requires_super));

@end
