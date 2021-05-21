//
//  EUTDefine.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/26.
//  Copyright © 2018 soundai. All rights reserved.
//

#ifndef EUTDefine_h
#define EUTDefine_h
//**********************************************************************************************
//****    AppID          ********************************************************************
//**********************************************************************************************
#define SaiAgoraAPIAPPID    @"97e1f44cc78a45c29cd0f32b4c4e92bc"
#define AgoraEngineAPPID    @"3a36a4bb4d494e17a171340341e20106"
#define parameterAPIKEY     @"BEAFVUZNVMSTX4PK:lW6uZ8LWE/lsBCWhfdHxruUZxoXu7Zh5VbXC4UyXH9k="
//#define parameterAPIKEY     @"BZ45XFG1E9ENQLXE:Z5ZfJo3jsaMwkfH4NRBMZJwLrqDPcpvhqEyUyX9QU6I="

#define        SoundAIAppId      @"1520137257"
#define TestUrl @"https://api-dev-azero.soundai.cn"
///**
// *  正式域名
// *
// *  @return 正式服务器
// */
#define ProductUrl @"https://api-azero.soundai.cn"
// *  fat域名
// *
// *  @return fat服务器
// */
#define fatUrl @"https://api-fat-azero.soundai.cn"
//#ifdef DEBUG
//
#define APPUrl fatUrl
//#else
//#define APPUrl ProductUrl
//#endif
//**********************************************************************************************
//****    UMKey          ********************************************************************
//**********************************************************************************************

#define SaiUMAppKey @"5c0b434db465f51615000d6b"


//**********************************************************************************************
//****    定义的通知          ********************************************************************
//**********************************************************************************************

#define SaiContext                  [UserInfoContext sharedContext]

#define kUserDefaults            [NSUserDefaults standardUserDefaults]


#define SaiNotificationCenter     [NSNotificationCenter defaultCenter]

//*********************************************************************************************
//****    RGB颜色        ********************************************************************
//**********************************************************************************************
#pragma mark Color
#define kColorFromARGBHex(value,a) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:a] //a:透明度

#define kColorFromRGBHex(value)     [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)) / 255.0 green:((float)((value & 0xFF00) >> 8)) / 255.0 blue:((float)(value & 0xFF)) / 255.0 alpha:1.0]
#define SaiColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define Color999999  kColorFromRGBHex(0x999999)
#define Color666666  kColorFromRGBHex(0x666666)
#define Color333333  kColorFromRGBHex(0x333333)
#define Color222B36  kColorFromRGBHex(0xA7B3A3)//app背景色
#define Color313944  kColorFromRGBHex(0x505B4D)// 视图背景色
#define Color67E4FD  kColorFromRGBHex(0x67E4FD)
#define Color505B4D kColorFromRGBHex(0x505B4D)

//**********************************************************************************************
//****   调试状态              *****************************************************************
//**********************************************************************************************

#ifdef DEBUG
// 打开LOG功能
//#define TYLog(format, ...) printf("%s [第%d--] %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#define TYLog(s, ... ) NSLog( @"[%@  %s in line %d--] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent],__FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else // 发布状态
// 关闭LOG功能
#define TYLog(...)
#endif

#pragma mark 系统文件位置

#define DOCUMENT_FOLDER(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:fileName]
#define CACHE_FOLDER(fileName)    [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]

//**********************************************************************************************
//****   屏幕尺寸             *****************************************************************
//**********************************************************************************************
//避免重复定义
#ifndef ScreenHeight
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#endif

#ifndef ScreenWidth
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#endif
#define kScreenScale   ([UIScreen mainScreen].scale)
#define ViewWidth      (self.view.bounds.size.width)
#define ViewHeight     (self.view.bounds.size.height)
#define kSCRATIO(x)   ceil(((x) * ([UIScreen mainScreen].bounds.size.width / 414)))

#define HScreenRatio   [UIScreen mainScreen].bounds.size.height/667
#define WScreenRatio   [UIScreen mainScreen].bounds.size.width/375
// 判断是否是iPhone X系列
#define IS_IPHONE_X      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)
#define kStatusBarHeight         (IS_IPHONE_X ? 44 : 20)
#define kNavHeight               (IS_IPHONE_X ? 88 : 64)
#define BOTTOM_HEIGHT            (IS_IPHONE_X ? 34 : 0)

#define _definecellHeight            kSCRATIO(70)



//**********************************************************************************************
//****    判断版本         ********************************************************************
//**********************************************************************************************

#define isIOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
#define isIOS11Low ([[UIDevice currentDevice].systemVersion doubleValue] < 11.0)
#define isIOS12 ([[UIDevice currentDevice].systemVersion doubleValue] >= 12.0)
#define isIOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define isIOS13 ([[UIDevice currentDevice].systemVersion doubleValue] >= 13.0)


#define blockWeakSelf __weak typeof(self) weakSelf = self
//tableview背景色
#define kTableViewBackColor                     [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1]


//机型判断
#define Sai_iPhone6  (ScreenWidth == 375.f && ScreenHeight == 667.f ? YES : NO)
#define Sai_iPhoneX  (ScreenWidth == 375.f && ScreenHeight == 812.f ? YES : NO)
#define Sai_iPhoneXS  (ScreenWidth == 375.f && ScreenHeight == 812.f ? YES : NO)
#define Sai_iPhoneXsXrMax  (ScreenWidth == 414.f && ScreenHeight == 896.f ? YES : NO)

/**
 * 懒加载
 */
#define TGLazyGetMethod(type, attribute)            \
- (type *)attribute                                 \
{                                                   \
if (!_##attribute) {                            \
_##attribute = [[type alloc] init];         \
}                                               \
return _##attribute;                            \
}

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define ViewContentMode(View)\
\
[View setContentMode:UIViewContentModeScaleAspectFill];\
[View setClipsToBounds:YES]
#endif /* EUTDefine_h */
