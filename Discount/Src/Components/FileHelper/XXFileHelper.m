//
//  IFFileManager.m
//  InfinitiNow
//
//  Created by Jason Li on 3/26/14.
//  Copyright (c) 2014 TapOrange. All rights reserved.
//

#import "XXFileHelper.h"

@implementation XXFileHelper

+ (NSString*)documentPath {
    return [self pathForType:NSDocumentDirectory];
}

+ (NSString*)libraryPath {
    return [self pathForType:NSLibraryDirectory];
}

+ (NSString*)cachePath {
    return [self pathForType:NSCachesDirectory];
}

+ (NSString*)tempPath {
    return NSTemporaryDirectory();
}

+ (NSString *)tempPathForSubdirectory:(NSString *)sub {
    return [self pathForRoot:[self tempPath] subdirectory:sub];
}

+ (NSString *)libraryPathForSubdirectory:(NSString *)sub {
    NSString *libraryPath = [self libraryPath];
    return [self pathForRoot:libraryPath subdirectory:sub];
}

+ (NSString *)cachesPathForSubdirectory:(NSString *)sub {
    NSString *cachesPath = [self cachePath];
    return [self pathForRoot:cachesPath subdirectory:sub];
}

+ (NSString *)pathForRoot:(NSString *)root subdirectory:(NSString *)sub {
    NSString *dir = [NSString stringWithFormat:@"%@/%@", root, sub];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        return dir;
    } else {
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
        if (success) {
            return dir;
        }
    }
    
    return nil;
}

+ (NSString *)pathForType:(NSSearchPathDirectory)directory {
    NSString *documentdir = [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) lastObject];
    return documentdir;
}


+ (unsigned long long int)folderSize:(NSString *)folderPath {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

//清除缓存
+ (void)cleanAllCacheWithCompletionBlock:(void(^)(void))completion {
    
    NSString *cachesPath = [self cachePath];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    for (NSString *file in [fileManager contentsOfDirectoryAtPath:cachesPath error:&error]) {
        NSString *filePath = [cachesPath stringByAppendingPathComponent:file];
        BOOL fileDeleted = [fileManager removeItemAtPath:filePath error:&error];
        if (fileDeleted != YES || error != nil) {
            // Deal with the error...
        }
    }
    
    if (completion) {
        completion();
    }
}

@end
