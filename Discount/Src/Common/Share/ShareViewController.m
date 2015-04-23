//
//  ShareViewController.m
//  Discount
//
//  Created by jackyzeng on 3/28/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShareViewController.h"
#import "IBShareView.h"

@interface ShareViewController () <ShareViewDelegate>

@property(nonatomic, strong) IBOutlet IBShareView *shareView;
@property(nonatomic, weak) id<ShareViewDelegate> delegate;

- (void)dismissAnimated:(BOOL)animated;

@end

//////////////////////// ShareTouchView ////////////////////////
@interface ShareTouchView : UIView

@property(nonatomic, weak) IBOutlet ShareViewController *controller;

@end

@implementation ShareTouchView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    for (UIView *subview in self.subviews) {
        if (CGRectContainsPoint(subview.frame, touchLocation)) {
            return;
        }
    }
    if (self.controller) {
        [self.controller dismissAnimated:YES];
    }
}

@end

//////////////////////// ShareViewController ////////////////////////

@implementation ShareViewController

- (instancetype)initWithShareViewDelegate:(id<ShareViewDelegate>)delegate {
    if (self = [super initWithNibName:@"ShareViewController" bundle:nil]) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.shareView.cancelButton addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)onCancel:(id)sender {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    self.view.backgroundColor = [UIColor clearColor];
    [self dismissViewControllerAnimated:animated completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewDidDismiss:)]) {
            [self.delegate shareViewDidDismiss:self.shareView];
        }
    }];
}

#pragma mark - ShareViewDelegate

- (void)shareView:(IBShareView *)shareView clickButtonWithType:(SocialShareType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:clickButtonWithType:)]) {
        [self.delegate shareView:shareView clickButtonWithType:type];
    }
}

@end
