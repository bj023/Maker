//
//  DismissButtonTextField.m
//  Discount
//
//  Created by jackyzeng on 3/31/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "DismissButtonTextField.h"

@implementation DismissButtonTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self customInputAccessoryView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customInputAccessoryView];
    }
    
    return self;
}

- (void)customInputAccessoryView {
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"des_cell_down"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(dismissKeyboard:)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 36)];
    [toolbar setTintColor:MAIN_THEME_COLOR];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    toolbar.items = @[space, dismissItem];
    self.inputAccessoryView = toolbar;
}

- (void)dismissKeyboard:(id)sender {
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
}

@end
