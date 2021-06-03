//
//  SaiUIUtils.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/10.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SaiUIUtils : NSObject
/**
 *  根据文本来计算高度
 *
 *  @param des  需要计算的文本
 *  @param font 文本的字体
 *  @param size 文本预定的大小
 *
 *  @return 文本的大小
 */
+ (CGSize)getSizeWithLabel:(NSString *)des withFont:(UIFont *)font withSize:(CGSize)size;
/**
 *  MD5加密
 *
 *  @param string 原始字符串
 *
 *  @return MD5加密后的字符串
 */
+ (NSString *) md5HexDigest:(NSString *)string;
/**
 *  正则判断密码：密码只能为8-16 位数字，字母及常用符号组成
 *
 *  @param password 密码字符串
 *
 *  @return 是否正确
 */
+(BOOL)isValidatePassWord:(NSString *)password;
/**
 *  正则判断验证码：验证码只能为6位数字
 *
 *  @param verification 验证码字符串
 *
 *  @return 是否正确
 */
+(BOOL)isVerification:(NSString *)verification;
/**
 *  描述：利用正则判断手机号格式是否正确
 *
 *  @param mobile 需要判断的手机号
 *
 *  @return 返回是否正确
 */
+ (BOOL) isValidateMobile:(NSString *)mobile;
/*******  计算label宽高 *********/
+ (CGSize)sizeLabelWithFont:(UIFont*)font AndText:(NSString*)text AndWidth:(float)width;
/**
 *  描述：利用正则判断第一位是不是数字
 *
 *  @param string 需要判断的字符串
 *
 *  @return 返回是否正确
 */
+ (BOOL) isFirstLetterNumber:(NSString *)string;
/**
 *  检测网络状况
 */
+ (BOOL)networkReachable;

/**
 *  生成随机验证码
 *
 *  @param num    验证码长度
 */
+ (NSString *)generateTradeNOWith:(int )num;
@end

NS_ASSUME_NONNULL_END
