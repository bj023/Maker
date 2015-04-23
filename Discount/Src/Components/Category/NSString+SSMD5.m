//
//  NSString+SSMD5.m
//  StarShow
//
//  Created by fengfeng on 15/1/6.
//  Copyright (c) 2015年 starshow. All rights reserved.
//

#import "NSString+SSMD5.h"

#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation NSString (SSMD5)
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}
@end

