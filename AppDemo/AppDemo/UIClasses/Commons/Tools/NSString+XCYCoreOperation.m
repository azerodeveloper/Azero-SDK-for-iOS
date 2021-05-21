//
//  NSString+XCYOperation.m
//  XCy
//
//  Created by XCY on 15/7/22.
//  Copyright (c) 2015年 XCY. All rights reserved.
//
#import "NSString+XCYCoreOperation.h"


@implementation NSString (XCYCoreOperation)
-(NSString *)trimString_xcy
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

}


+ (NSString *)safeGet_xcy:(NSString *)str
{
    if (!str) {
        return @"";
    }
    return str;
}

- (nullable NSData *)dataFromHexString_xcy
{
    const char *chars = [self UTF8String];
    int i = 0;
    NSUInteger len = self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

+ (NSString*)stringFromData_cmbc:(NSData *)data
{
    if (!data) {
        return @"";
    }
    
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([data length] * 2)];
    const unsigned char *dataBuffer = [data bytes];
    for (int i = 0; i < [data length]; ++i)
    {
        [stringBuffer appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
    }
    
    return stringBuffer;
}
+ (NSString*)stringFromData_cmbc1:(NSData *)data
{
    if (!data) {
        return @"";
    }
    
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([data length] * 2)];
    const unsigned char *dataBuffer = [data bytes];
    for (int i = 0; i < [data length]; ++i)
    {
        [stringBuffer appendFormat:@"%lX", (unsigned long)dataBuffer[i]];
    }
    
    return stringBuffer;
}


@end
