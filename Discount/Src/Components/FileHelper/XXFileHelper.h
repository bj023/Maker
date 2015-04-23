//
//  IFFileManager.h
//  InfinitiNow
//
//  Created by Jason Li on 3/26/14.
//  Copyright (c) 2014 TapOrange. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CacheDirAPI @"api"

@interface XXFileHelper : NSObject

+ (NSString*)documentPath;
+ (NSString*)libraryPath;
+ (NSString*)cachePath;
/*
 The Caches directory is where you store cache files and other temporary data that your application can re-create as needed. This directory is located inside the Library directory.
 Never store files at the top level of this directory: Always put them in a subdirectory named for your application or company. Your application is responsible for cleaning out cache data files when they are no longer needed. The system does not delete files from this directory.
 */
+ (NSString *)cachesPathForSubdirectory:(NSString *)sub; //文件缓存目录
+ (NSString *)libraryPathForSubdirectory:(NSString *)sub; //库文件目录
+ (NSString *)tempPathForSubdirectory:(NSString *)sub; //临时目录

//清除缓存
+ (void)cleanAllCacheWithCompletionBlock:(void(^)(void))completion;

//计算文件夹容量
+ (unsigned long long int)folderSize:(NSString *)folderPath;

@end
