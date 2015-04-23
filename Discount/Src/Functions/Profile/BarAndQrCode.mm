//
//  BarAndQrCode.m
//  Discount
//
//  Created by bilsonzhou on 15/3/27.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "BarAndQrCode.h"
#import <BarCodeKit/BarCodeKit.h>
#import <BarCodeKit/BCKUPCACode.h>

@implementation BarAndQrCode

+ (UIImage *)generateQRCodeWithString:(NSString *)string scale:(CGFloat)scale {
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding ];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:stringData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // Render the image into a CoreGraphics image
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:[filter outputImage] fromRect:[[filter outputImage] extent]];
    
    //Scale the image usign CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake([[filter outputImage] extent].size.width * scale, [filter outputImage].extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *preImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //Cleaning up .
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    // Rotate the image
    UIImage *qrImage = [UIImage imageWithCGImage:[preImage CGImage]
                                           scale:[preImage scale]
                                     orientation:UIImageOrientationDownMirrored];
    return qrImage;
}

+ (UIImage *)doQREncodeWithString:(NSString *)str size:(NSInteger)size {
    
    return [self generateQRCodeWithString:str scale:2 * [UIScreen mainScreen].scale];
}

+ (UIImage *)doBarEncodeWithString:(NSString *)str size:(NSInteger)size {
    NSError *error = nil;
    NSDictionary *options = @{BCKCodeDrawingBarScaleOption: @([[UIScreen mainScreen] scale])};
    BCKCode *code = nil;
    if (str.length == 13) {
        code = [[BCKEAN13Code alloc] initWithContent:str error:&error];
    }
    else {
        code = [[BCKUPCACode alloc] initWithContent:str error:&error];
    }
    if (error) {
        SSLog(@"条形码错误：string<%@>, error<code: %d, description: %@>", str, (int)[error code], [error localizedDescription]);
    }
    if (code == nil) {
        return nil;
    }
    return [UIImage imageWithBarCode:code options:options];
    
}

@end
