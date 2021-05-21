//
//  QKUITools.h
//  Sekey
//
//  Created by silk on 2017/4/1.
//  Copyright © 2017年 silk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaiBaseRootController.h"
typedef NS_ENUM(NSInteger, TemplateTypeENUM)
{
    WeatherTemplate =0,
    WalkingTemplate=1,
    RunningTemplate=2,
    QuestionGameTemplate=3,
    DefaultTemplate1=4,
    BodyTemplate1=5,
    RenderPlayerInfo=6,
    NewsTemplate=7,
    EnglishTemplate=8,
    ASMRRenderPlayerInfo=9,
    LauncherTemplate1=10,
    AlertRingtoneTemplate=11
};

@interface QKUITools : NSObject
/**
 *  侧栏 传入时间戳返回对应的时间格式
 *
 *  @param timeStamp 时间戳
 *
 *  @return 时间字符串
 */

+ (NSString*)lockDatetimeStringByTimeStamp:(long long)timeStamp;

/**
 *  侧栏 传入时间戳返回对应的时间格式
 *
 *  @param timeStamp 时间戳
 *
 *  @return 时间字符串
 */

+ (NSString*)sidEtimeStringByTimeStamp:(long long)timeStamp;
/**
 *  传入时间戳返回对应的时间格式
 *
 *  @param timeStamp 时间戳
 *
 *  @return 时间字符串
 */
+ (NSString*)timeStringByTimeStamp:(long long)timeStamp;

/**
 *  侧栏 传入时间戳返回对应的时间格式
 *
 *  @param timeStamp 时间戳
 *
 *  @return 时间字符串
 */

+ (NSString*)hoursAndMinutesStringByTimeStamp:(long long)timeStamp;

+ (NSString *)timeFormattedHHMM:(int)totalSeconds;

+ (NSString *)timeFormattedWithMMSS:(int)totalSeconds;

+ (NSString *)timeFormatted:(int)totalSeconds;
/**
 *  搜索字体高亮方法
 *
 *  @param content 显示的字符串
 *  @param search  输入的文字（显示为高亮）
 *  @param font    字体大小
 *
 *  @return 返回字符串
 */
+ (NSMutableAttributedString *)stringFromContent:(NSString *)content search:(NSString *)search withFont:(UIFont *)font;

/**
 *  传入时间戳返回对应的时间格式
 *
 *  @param timeStamp 时间戳
 *
 *  @return 时间字符串
 */
+ (NSString *)dialogViewTimeStringByTimeStamp:(long long)timeStamp;
/**
*  获取当前时间戳
*
*  @return 时间戳
 */
+(NSString *)getNowTimeStamp ;

+(NSString *)getNowmmdd;

+(NSString *)getNowyyyymmdd;

+(NSString *)getNowyyyymmddmmss;

+ (CGSize)getTextHeight:(NSString *)text hight:(CGFloat)hight font:(UIFont *)font;

+ (CGSize)getTextHeight:(NSString *)text width:(CGFloat)width font:(UIFont *)font ;

+ (CGFloat)widthForText:(NSString *)text withheight:(CGFloat)height ;

/**
 *  字符串判断空
 */
+ (BOOL)isBlankString:(NSString *)string;
/**
 *  判断数组是否为空
 *
 *  @param array 传入要判断的数组
 *
 *  @return 返回的bool值为YES则为空
 */
+ (BOOL)isBlankArray:(NSArray *)array;

+(BOOL)isBlankDictionary:(NSDictionary *)dictionary;

/**
 * @brief 将字符串转化为控制器.
 *
 * @param str 需要转化的字符串.
 *
 * @return 控制器(需判断是否为空).
 */
+ (SaiBaseRootController*)stringChangeToClass:(NSString *)str ;
/**
 *  传入数据
 *
 *  @param array 传入要判断的数据
 *
 *  @return 返回对应的Template
 */
+ (TemplateTypeENUM )returnTemplateFromRenderTemplateStr:(NSString *)renderTemplateStr;
/**
*   是否耳机接入
*
*  @return 返回耳机接入的状态
*/
+(BOOL)isHeadsetPluggedIn;
/**
*   是否是声智耳机
*
*  @return 返回是否是声智耳机
*/
+(BOOL)isSaiHeadsetPluggedIn;


+(BOOL)isSaiHeadsetNeedBle;


/**
 *  根据宽度计算图片的高度
 *
 *  @param image     图片
 *  @param cellWidth 宽度
 *
 *  @return 图片保持比例的高度
 */
+ (CGFloat)heightForImage:(UIImage *)image withCellWidth:(CGFloat)cellWidth;

/**
 *  根据高度计算图片的宽度
 *
 *  @param image  图片
 *  @param height 高度
 *
 *  @return 图片保持比例的宽度
 */
+ (CGFloat)widthForImage:(UIImage *)image withHeight:(CGFloat)height;

/**
 *  根据大小缩放图片
 *
 *  @param image 图片
 *  @param size  缩放的大小
 *
 *  @return 缩放完成之后的大小
 */
+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;
/**
 *  传入时间戳返回对应的时间格式
 *
 *  @param timeStamp 时间戳
 *
 *  @return 管理模式下门锁首页的时间
 */
+ (NSString*)timeStringManagerLockByTimeStamp:(long long)timeStamp;


/**
 *  检测网络状况
 */
+ (BOOL)networkReachable;



/**
 如果字符串中含有emoji, 防止出现异常的截断
 
 @param originStirng 需要处理字符串
 @param length 最大长度
 @return 最接近最大长度的字符串, 不含有异常截断的emoji
 */
+ (NSString *)limitLengthString:(NSString *)originStirng maxLength:(NSUInteger)length;

+ (NSString *)multiUserSendDetailTimeStringByTimeStamp:(long long)timeStamp;

+ (NSString*)timeStringByTimeStampOpenLock:(long long)timeStamp;

+ (NSString*)sidePromptTimeStringByTimeStamp:(long long)timeStamp;
#pragma mark 获取当前视图控制器
+ (UIViewController *)getCurrentVC;
///回到(dismiss)到最初始的页面
+(void)dissRootViewController:(UIViewController *)viewController;
#pragma mark 加密算法
+(NSString *)signStr:(NSMutableDictionary*)dict;

@end
