//
//  XCYFileUtil.h
//  XCYBusinessCard
//
//  Created by XCY on 15-3-3.
//  Copyright (c) 2015年 XCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCYFileUtil : NSObject

/*
 *获取沙盒目录 */

+ (NSString *)fileHomeDir;

/*
 *获取Resource资源文件目录*/

+ (NSString *)fileResourceDir;

/*
 *获取Resource资源文件目录并附加path路径
 *path 文件名或相对路径*/

+ (NSString *)fileResourceDir:(NSString *)path;

/*获取Documents目录*/

+ (NSString *)fileDocDir;

/*
 *获取Documents目录并附加path路径
 *path 文件名或相对路径*/

+ (NSString *)fileDocDir:(NSString *)path;

/*获取Cache缓存目录*/

+ (NSString *)fileCacheDir;

/*获取Cache缓存目录并附加path路径
 *path 文件名或相对路径*/

+ (NSString *)fileCacheDir:(NSString *)path;

/*获取temp临时文件夹目录*/

+ (NSString *)fileTempDir;

/*获取temp临时文件夹目录并附加path路径
 *文件名或相对路径*/

+ (NSString *)fileTempDir:(NSString *)path;

/*创建目录或文件路径
 *path 目录或文件路径
 *BOOL 创建是否成功*/

+ (BOOL)fileCreateDir:(NSString *)path;

/**
 *  创建文件
 *
 *  @param path 文件路径
 *  @param contentData 文件内容
 *  @return 是否创建成功
 */
+ (BOOL)fileCreateFile:(NSString *)path content:(NSData *)contentData;

/*
 *目录或文件路径是否存在
 *path 目录或文件路径
 *BOOL 是否存在目录或文件路径*/

+ (BOOL)fileExistAtPath:(NSString *)path;

/*
 *将data数据写入到path路径下
 *path 目标文件路径
 *data 源文件数据
 *BOOL 写文件是否成功*/

+ (BOOL)fileWriteAtPath:(NSString *)path data:(NSData *)data;

/*
 *删除目录或文件
 *path 待删除目录或文件路径
 *BOOL 删除是否成功*/

+ (BOOL)fileDel:(NSString *)path;

/*
 *查询path路径下子文件名称列表
 *path 待查询目录或文件路径
 *NSArray 子文件名称列表(注：可能含系统隐藏文件".DS_Store")*/

+ (NSArray *)fileSubFileNames:(NSString *)path;
/*
 *将fromPath源文件拷贝到toPath路径下
 *fromPath 源文件路径
 *toPath 目标文件路径
 *BOOL 文件拷贝是否成功*/

+ (BOOL)fileCopy:(NSString *)fromPath toPath:(NSString *)toPath;

@end
