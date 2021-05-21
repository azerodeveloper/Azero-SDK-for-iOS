//
//  XCYOTAFileBusiness.m
//  XCYBlueBox
//
//  Created by XCY on 2017/4/23.
//  Copyright © 2017年 XCY. All rights reserved.
//

#import "XCYOTAFileBusiness.h"

@implementation XCYOTAFileBusiness


- (NSArray<NSString *> *)getOTAbinFileList
{
    NSMutableArray *searchArray = [[NSMutableArray alloc] initWithCapacity:1];

    
    //获取沙盒里所有文件
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSString *documentDir = [XCYFileUtil fileDocDir];
    NSError *error = nil;
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    
    for (NSString *file in fileList) {

        if ([file hasSuffix:@".bin"]) {
            
            [searchArray addObject:file];
        }
    }
    
    return searchArray;
    
}

- (NSArray<NSString *> *)getOTAOtherFileListWithType:(NSString *)type {
    NSMutableArray *searchArray = [[NSMutableArray alloc] initWithCapacity:1];

    
    //获取沙盒里所有文件
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSString *documentDir = [XCYFileUtil fileDocDir];
    NSError *error = nil;
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    
    for (NSString *file in fileList) {
        
        if ([file hasSuffix:type]) {
            
            [searchArray addObject:file];
        }
    }
    
    return searchArray;
}
@end

