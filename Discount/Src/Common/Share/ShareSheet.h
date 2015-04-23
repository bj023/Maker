//
//  ShareSheet.h
//  Discount
//
//  Created by jackyzeng on 3/12/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareSheet : NSObject

+ (instancetype)sharedInstance;

- (BOOL)shareWithContent:(NSString *)content
          defaultContent:(NSString *)defaultContent
                   image:(UIImage *)image
                   title:(NSString *)title
                     url:(NSString *)url
             description:(NSString *)description;

@end
