//
//  SaiUIUtils.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "SaiUIUtils.h"
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SaiUIUtils
+ (CGSize)getSizeWithLabel:(NSString *)des withFont:(UIFont *)font withSize:(CGSize)aSize
{
    if (![des isMemberOfClass:[NSNull class]]) {
        CGSize size;
        
        NSDictionary *attribute = @{NSFontAttributeName: font};
        //iOS7中提供的计算文本尺寸的方法
        size = [des boundingRectWithSize:aSize
                                 options:NSStringDrawingUsesLineFragmentOrigin |
                NSStringDrawingTruncatesLastVisibleLine
                              attributes:attribute
                                 context:nil].size;
        
        
        
        
        return size;
    }
    return CGSizeZero;
}
+ (NSString *) md5HexDigest:(NSString *)string
{
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
/**
 *  正则判断密码
 *
 *  @param password 密码字符串
 *
 *  @return 是否正确
 */
+(BOOL)isValidatePassWord:(NSString *)password
{
    // 密码必须是6-12位数字、字符组合
    BOOL result = false;
    if ([password length] >= 6&&[password length]<=12){
        //        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        //        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
        //        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        //        result = [pred evaluateWithObject:password];
        result = YES;
    }
    return result;
}
/**
 *  正则判断验证码：验证码只能为6位数字
 *
 *  @param verification 验证码字符串
 *
 *  @return 是否正确
 */
+(BOOL)isVerification:(NSString *)verification{
    // 密码必须是8-16位数字、字符组合
    BOOL result = false;
    if ([verification length] == 6){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^[0-9]*$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:verification];
    }
    return result;
}
/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[0-9])|(18[0,0-9])|(17[^4,\\D]))\\d{8}$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    return [phoneTest evaluateWithObject:mobile];
    return mobile.length == 11;
    
}
+ (CGSize)sizeLabelWithFont:(UIFont*)font AndText:(NSString*)text AndWidth:(float)width
{
    CGSize size;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    //iOS7中提供的计算文本尺寸的方法
    size = [text boundingRectWithSize:CGSizeMake(width, 0)
                              options:NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingTruncatesLastVisibleLine
                           attributes:attribute
                              context:nil].size;
    
    return size;
}
+ (BOOL) isFirstLetterNumber:(NSString *)string{
    NSString *phoneRegex = @"^[0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:string];
}
/**
 *  检测网络状况
 */
+ (BOOL)networkReachable{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return status != NotReachable;
}

/**
 *  生成随机验证码
 *
 *  @param len    验证码长度
 *  @param buffer 接收的指针
 */
void generate(int len,char* buffer)
{
    /*产生密码用的字符串*/
    // 秘钥字符串 0123456789abcdefghiljklnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
    static const char string[]= "0123456789";
    
    for(int i = 0; i < len; i++)
    {
        buffer[i] = string[rand()%strlen(string)]; /*产生随机数*/
    }
}
/**
 *  生成随机验证码
 *
 *  @param num    验证码长度
 */
+ (NSString *)generateTradeNOWith:(int )num{
    int kNumber = num;
    NSString *sourceStr = @"0123456789abcdefdhijklmnopqrstuvwxyz";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++){
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
