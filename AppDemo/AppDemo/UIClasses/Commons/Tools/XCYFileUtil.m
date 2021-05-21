//
//  XCYFileUtil.m
//  XCYBusinessCard
//
//  Created by XCY on 15-3-3.
//  Copyright (c) 2015年 XCY. All rights reserved.
//

#import "XCYFileUtil.h"

@implementation XCYFileUtil


+ (NSString *)fileHomeDir{
    NSString *path = NSHomeDirectory();
    return path;
}

+ (NSString *)fileResourceDir{
    NSString *path = [[NSBundle mainBundle] resourcePath];
    return path;
}

+ (NSString *)fileResourceDir:(NSString *)path{
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resPath stringByAppendingPathComponent:path];
    return filePath;
}

+ (NSString *)fileDocDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    docDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"FileCache"];
    return docDir;
}

+ (NSString *)fileDocDir:(NSString *)path {
    NSString *docDir = [XCYFileUtil fileDocDir];
    NSString *filePath = [docDir stringByAppendingPathComponent:path];
    return filePath;
}

+ (NSString *)fileCacheDir{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cache objectAtIndex:0];
    return cachePath;
}

+ (NSString *)fileCacheDir:(NSString *)path{
    NSString *cacheDir = [XCYFileUtil fileCacheDir];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:path];
    return filePath;
}

+ (NSString *)fileTempDir {
    return NSTemporaryDirectory();
}

+ (NSString *)fileTempDir:(NSString *)path {
    NSString *tempDir = [XCYFileUtil fileTempDir];
    NSString *filePath = [tempDir stringByAppendingPathComponent:path];
    return filePath;
}

+ (BOOL)fileCreateDir:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    if (!success) {
        
//        commonFunction.showLog(@"fileCreateDir Error : %@",[error localizedDescription]);
    }
    return success;
}

+ (BOOL)fileCreateFile:(NSString *)path content:(NSData *)contentData
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL success = [fm createFileAtPath:path contents:contentData attributes:nil];
    return success;
}

+ (BOOL)fileExistAtPath:(NSString *)path {
    NSFileManager *filemanager = [NSFileManager defaultManager];
    return [filemanager fileExistsAtPath:path];
}

+ (BOOL)fileWriteAtPath:(NSString *)path data:(NSData *)data {
    return [data writeToFile:path atomically:NO];
}

+ (BOOL)fileDel:(NSString *)path {
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [filemanager removeItemAtPath:path error:&error];
    if (!success) {
        
//        commonFunction.showLog(@"fileDel Error : %@",[error localizedDescription]);
    }
    return success;
}

+ (NSArray *)fileSubFileNames:(NSString *)path{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *names = [filemanager contentsOfDirectoryAtPath:path error:&error];
    if (nil == names) {
        
//        commonFunction.showLog(@"fileSubFileNames Error : %@",[error localizedDescription]);
    }
    return names;
}

+ (BOOL)fileCopy:(NSString *)fromPath toPath:(NSString *)toPath
{
    BOOL success = NO;
    if (![XCYFileUtil fileExistAtPath:fromPath]) {
        
//        commonFunction.showLog(@"fileCopy Error : from file is error");
    
        success = NO;
    }
    else {
        NSFileManager *filemanager = [NSFileManager defaultManager];
        NSError *error;
        success = [filemanager copyItemAtPath:fromPath toPath:toPath error:&error];
        if (!success) {
            
//            commonFunction.showLog(@"fileCopy Error : %@",[error localizedDescription]);
        }
    }
    return success;
}


@end
