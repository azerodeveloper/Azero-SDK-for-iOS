//
//  QKUITools.m
//  Sekey
//
//  Created by silk on 2017/4/1.
//  Copyright © 2017年 silk. All rights reserved.
//

#import "QKUITools.h"
#import "Reachability.h"

typedef enum TemplateTypeENUM TemplateTypeENUM;

const NSArray *___TemplateType;
#define TemplateGet (___TemplateType == nil ? ___TemplateType = [[NSArray alloc] initWithObjects:\
@"WeatherTemplate",\
@"WalkingTemplate",\
@"RunningTemplate",\
@"QuestionGameTemplate",\
@"DefaultTemplate1",\
@"BodyTemplate1",\
@"RenderPlayerInfo",\
@"NewsTemplate",\
@"EnglishTemplate",\
@"ASMRRenderPlayerInfo",\
@"LauncherTemplate1",\
@"AlertRingtoneTemplate",nil] : ___TemplateType)
#define  NetworkTypeEnum(string) ([TemplateGet indexOfObject:string])
#define cDPodRecordTypeString1(type) ([TemplateGet objectAtIndex:type])
@implementation QKUITools
#pragma mark - 时间格式
+ (NSString*)lockDatetimeStringByTimeStamp:(long long)timeStamp{
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    fmt.dateFormat = @" yyyy/M/d HH:mm";
    return [fmt stringFromDate:createDate];
    
}

+ (NSString*)timeStringByTimeStamp:(long long)timeStamp{
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    // 当前时间
    if ([createDate isToday]) { // 今天
        return @"今天";
    } else if ([createDate isYesterday]) { // 昨天
        return @"昨天";
    } else { // 其他日子
        fmt.dateFormat = @"M月dd日";
        return [fmt stringFromDate:createDate];
    }
}
+ (NSString*)timeStringByTimeStampOpenLock:(long long)timeStamp{
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    // 当前时间
    if ([createDate isToday]) { // 今天
        fmt.dateFormat = @"HH:mm:ss";
        return [NSString stringWithFormat:@"%@ %@",@"今天",[fmt stringFromDate:createDate]];
    } else if ([createDate isYesterday]) { // 昨天
        fmt.dateFormat = @"HH:mm:ss";
        return [NSString stringWithFormat:@"%@ %@",@"昨天",[fmt stringFromDate:createDate]];
    } else { // 其他日子
        fmt.dateFormat = @"M月dd日 HH:mm:ss";
        return [fmt stringFromDate:createDate];
    }
}
+ (NSString*)hoursAndMinutesStringByTimeStamp:(long long)timeStamp{
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    // 当前时间
    if ([createDate isToday]) { // 今天
        fmt.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"%@",[fmt stringFromDate:createDate]];
    } else if ([createDate isYesterday]) { // 昨天
        fmt.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"%@",[fmt stringFromDate:createDate]];
    } else { // 其他日子
        fmt.dateFormat = @"HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

+ (NSString*)sidEtimeStringByTimeStamp:(long long)timeStamp{
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    // 当前时间
    if ([createDate isToday]) { // 今天
        fmt.dateFormat = @"HH:mm:ss";
        return [NSString stringWithFormat:@"今天 %@",[fmt stringFromDate:createDate]];
    } else if ([createDate isYesterday]) { // 昨天
        fmt.dateFormat = @"HH:mm:ss";
        return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:createDate]];
    } else { // 其他日子
        fmt.dateFormat = @"M月dd日 HH:mm:ss";
        return [fmt stringFromDate:createDate];
    }
}
+ (NSString*)sidePromptTimeStringByTimeStamp:(long long)timeStamp{
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    // 当前时间
    if ([createDate isToday]) { // 今天
        fmt.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"今天 %@",[fmt stringFromDate:createDate]];
    } else if ([createDate isYesterday]) { // 昨天
        fmt.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:createDate]];
    } else { // 其他日子
        fmt.dateFormat = @"M月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
}


+ (NSString *)multiUserSendDetailTimeStringByTimeStamp:(long long)timeStamp{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    // 当前时间
    if ([createDate isToday]) { // 今天
        
        
        fmt.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"今天 %@",[fmt stringFromDate:createDate]];
        
        
    } else if ([createDate isYesterday]) { // 昨天
        
        fmt.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:createDate]];
        
    } else if ([createDate isThisYear]) { // 今年
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }else{
        
        fmt.dateFormat = @"YY-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}


+ (BOOL)dateHasAMPM{
    //获取系统是24小时制或者12小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    return hasAMPM;
    //hasAMPM==TURE为12小时制，否则为24小时制
    
}
+ (NSString *)dialogViewTimeStringByTimeStamp:(long long)timeStamp {
    // 公众号的时间戳, 会多1000.
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    fmt.dateFormat = @"HH:mm:ss";
    return [fmt stringFromDate:createDate];
}
+(NSString *)getNowTimeStamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    
    
    //设置时区,这一点对时间的处理很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *dateNow = [NSDate date];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    return timeStamp;
    
}

/**
 *  获取当天的年月日的字符串
 *  @return 格式为月-日
 */
+(NSString *)getNowyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy年MM月dd日";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}
+(NSString *)getNowyyyymmddmmss{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}
/**
 *  获取当天的年月日的字符串
 *  @return 格式为月-日
 */
+(NSString *)getNowmmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"MM月dd日";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}
+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
+ (NSString *)timeFormattedHHMM:(int)totalSeconds
{
    
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;

    return hours>=1?[NSString stringWithFormat:@"%d时%d分",hours, minutes]:[NSString stringWithFormat:@"%d分", minutes];
}
+ (NSString *)timeFormattedWithMMSS:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
#pragma mark - 文本

//字体高亮方法
+ (NSMutableAttributedString *)stringFromContent:(NSString *)content search:(NSString *)search withFont:(UIFont *)font {
    if (!content) {
        content = @"";
    }
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:content];
    if (search == nil) {
        
    } else {
        NSRange range = [content rangeOfString:search options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound) {
            return str;
        }
        //        [str addAttribute:NSForegroundColorAttributeName value:[UIColor xm_searchTextColor] range:range];
        [str addAttribute:NSFontAttributeName value:font range:range];
    }
    return str;
}



+ (CGFloat)widthForText:(NSString *)text withheight:(CGFloat)height {
    UILabel *label = [[UILabel alloc] init];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.numberOfLines = 0;
    
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, height)];
    return size.width;
}

//判断输入的字符是否为空 空格算空字符串
+ (BOOL)isBlankString:(NSString *)string
{
      string = [NSString stringWithFormat:@"%@",string];
       
       if (string == nil) {
           return YES;
       }
       
       if (string == NULL) {
           return YES;
       }
       if ([string isEqual:[NSNull null]]) {
           return YES;
       }
       if ([string isEqualToString:@"(null)"]) {
           return YES;
       }
       if([string isEqualToString:@"<null>"])
       {
           return YES;
       }
       if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
           return YES;
       }
    
    return NO;
}
+ (BOOL)isBlankArray:(NSArray *)array
{
    if (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
    {
        return YES;
    }
    return NO;
}
+(BOOL)isBlankDictionary:(NSDictionary *)dictionary
{
    if (dictionary == nil || [dictionary isKindOfClass:[NSNull class]] || dictionary.count == 0)
    {
        return YES;
    }
    return NO;
}
/**
 * @brief 将字符串转化为控制器.
 *
 * @param str 需要转化的字符串.
 *
 * @return 控制器(需判断是否为空).
 */
+ (SaiBaseRootController*)stringChangeToClass:(NSString *)str {
    id vc = [[NSClassFromString(str) alloc]init];
    if ([vc isKindOfClass:[SaiBaseRootController class]]) {
        return (SaiBaseRootController *)vc;
    }
    return nil;
}
+ (TemplateTypeENUM )returnTemplateFromRenderTemplateStr:(NSString *)renderTemplateStr{
    
    TemplateTypeENUM template =  NetworkTypeEnum(renderTemplateStr);
    return template;
}
+(BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription *currentRount = [AVAudioSession sharedInstance].currentRoute;
    BOOL headphonesLocated = NO;
    for (AVAudioSessionPortDescription *outputPortDesc in currentRount.outputs) {
        if ([outputPortDesc.portType isEqualToString:AVAudioSessionPortBluetoothLE]||[outputPortDesc.portType isEqualToString:AVAudioSessionPortBluetoothHFP]||[outputPortDesc.portType isEqualToString:AVAudioSessionPortBluetoothA2DP]||[outputPortDesc.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            headphonesLocated = YES;
        }
    }
    return headphonesLocated;
    
}
/**
*   是否是声智耳机
*
*  @return 返回是否是声智耳机
*/
+(BOOL)isSaiHeadsetPluggedIn{
    AVAudioSessionRouteDescription *currentRount = [AVAudioSession sharedInstance].currentRoute;
    BOOL headphonesLocated = NO;
    for (AVAudioSessionPortDescription *outputPortDesc in currentRount.outputs) {
        if ([outputPortDesc.portName isEqualToString:@"M18 Pro"]||[outputPortDesc.portName isEqualToString:@"SoundAI TA"]) {
            headphonesLocated = YES;
        }
    }
    return headphonesLocated;
}
//处理@提醒字符串
+ (NSString *)resolveRemindString:(NSString *)string {
    NSMutableString *resultString = [[NSMutableString alloc] init];
    if (string.length > 0) {
        [resultString appendString:@"@"];
        [resultString appendString:string];
        [resultString appendString:@" "];
    }
    return resultString;
}
#pragma mark - 图片
///图片的高度
+ (CGFloat)heightForImage:(UIImage *)image withCellWidth:(CGFloat)cellWidth {
    //(2)获取图片的大小
    CGSize size = image.size;
    //(3)求出缩放比例
    CGFloat scale = cellWidth / size.width;
    CGFloat imageHeight = size.height * scale;
    return imageHeight;
}

///图片的宽度
+ (CGFloat)widthForImage:(UIImage *)image withHeight:(CGFloat)height {
    //(2)获取图片的大小
    CGSize size = image.size;
    //(3)求出缩放比例
    CGFloat scale = height / size.height;
    CGFloat imageWidth = size.width * scale;
    return imageWidth;
}

+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    
    //绘制图片的大小
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //从当前context中创建一个改变大小后的图片
    UIImage *endImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return endImage;
}


+ (BOOL)networkReachable {
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return status != NotReachable;
}


+ (BOOL)isValidUserId:(long long)chatID{
    BOOL isUserId=NO;
    if (chatID>=100000000&&chatID<=9999999999) {
        isUserId=YES;
    }
    return isUserId;
}


+ (NSString *)limitLengthString:(NSString *)originStirng maxLength:(NSUInteger)length{
    NSRange emojiRange;
    
    NSMutableString *mEmojiString = [NSMutableString string];
    for (int i = 0; i < originStirng.length ; i += emojiRange.length ) {
        @autoreleasepool {
            NSMutableString *emojiTString = [mEmojiString mutableCopy];
            emojiRange = [originStirng rangeOfComposedCharacterSequenceAtIndex:i];
            NSString *subStr = [originStirng substringWithRange:emojiRange];
            [emojiTString appendString:subStr];
            
            if (emojiTString.length <= length) {
                [mEmojiString appendString:subStr];
            }else{
                break;
            }
        }
    }
    
    return mEmojiString;
}

+ (NSString*)timeStringManagerLockByTimeStamp:(long long)timeStamp{
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm";
    return [fmt stringFromDate:createDate];
}
+(void)dissRootViewController:(UIViewController *)viewController{
    UIViewController *present = viewController.presentingViewController;
    while (YES) {
        if (present.presentingViewController) {
            present = present.presentingViewController;
        }else{
            break;
        }
    }
      
    [present dismissViewControllerAnimated:YES completion:nil];
}
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    if ([QKUITools isBlankArray:[window subviews]]) {
        return window.rootViewController;
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
#pragma mark 加密算法
//签名算法
//签名生成的通用步骤如下：
//第一步，设所有发送或者接收到的数据为集合M，将集合M内非空参数值的参数按照参数名ASCII码从小到大排序（字典序），使用URL键值对的格式（即key1=value1&key2=value2…）拼接成字符串stringA。
//特别注意以下重要规则：
//◆ 参数名ASCII码从小到大排序（字典序）；
//◆ 如果参数的值为空不参与签名；
//◆ 参数名区分大小写；


+(NSString *)signStr:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    
    [contentString appendString:[NSString stringWithFormat:@"secretKey=ddd350686b649a109c3689ec128d19e3"]];
    NSString *signStr = [[contentString md5String] uppercaseString];
    
    return signStr;
}
@end
