//
//  NSString+Ext.m
//  v2ex
//
//  Created by Haven on 18/2/14.
//  Copyright (c) 2014 LF. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString (Ext)
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
#else
    expectedLabelSize = [self sizeWithFont:font
                         constrainedToSize:size
                             lineBreakMode:NSLineBreakByWordWrapping];
#endif
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

@end
