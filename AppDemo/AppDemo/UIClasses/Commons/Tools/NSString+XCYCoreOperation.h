//
//  NSString+XCYStrOperation.h
//  XCY
//
//  Created by XCY on 15/7/22.
//  Copyright (c) 2015年 XCY. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (XCYCoreOperation)
- (NSString *)trimString_xcy;
/**
 *  安全获取，如果str为空那么返回@""
 *
 *  @param str 目标字符串
 *
 *  @return 字符串
 */
+ (NSString *)safeGet_xcy:(NSString *)str;


+ (NSString*)stringFromData_cmbc:(NSData *)data;

+ (NSString*)stringFromData_cmbc1:(NSData *)data;

- (NSData *)dataFromHexString_xcy;
@end
