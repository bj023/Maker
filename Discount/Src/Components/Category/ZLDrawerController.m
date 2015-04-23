//
//  ZLDrawerController.m
//  Discount
//
//  Created by jackyzeng on 4/2/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ZLDrawerController.h"

@interface DrawerMaskView : UIView

@end

@implementation DrawerMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

@end

@interface MMDrawerController (Private)

// Hook private methods
- (id)centerContainerView;

@end

@interface ZLDrawerController ()

@property(nonatomic, strong) DrawerMaskView *maskView;

@end

@implementation ZLDrawerController

typedef void(^ DrawerFinishBlock)(BOOL finished);

-(void)closeDrawerAnimated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion {
    DrawerFinishBlock finishBlock = ^(BOOL finished) {
        self.maskView.hidden = YES;
        completion(finished);
    };
    
    [super closeDrawerAnimated:animated velocity:velocity animationOptions:options completion:finishBlock];
}

-(void)openDrawerSide:(MMDrawerSide)drawerSide animated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion {
    UIView *containerView = (UIView *)[self centerContainerView];
    if (self.maskView == nil) {
        self.maskView = [[DrawerMaskView alloc] initWithFrame:containerView.bounds];
        self.maskView.hidden = YES;
        [containerView addSubview:self.maskView];
    }
    
    DrawerFinishBlock finishBlock = ^(BOOL finished) {
        self.maskView.hidden = NO;
        completion(finished);
    };
    
    [super openDrawerSide:drawerSide animated:animated velocity:velocity animationOptions:options completion:finishBlock];
}

@end
