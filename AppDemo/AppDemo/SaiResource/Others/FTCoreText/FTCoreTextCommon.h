//
//  FTCoreTextCommon.h
//  RCS
//
//  Created by qxxw_a_n on 13-11-2.
//  Copyright (c) 2013年 feinno. All rights reserved.
//

#import "FTCoreTextView.h"


#define regex_http  @"((http|ftp|https)://)?(www\\.)?((([a-zA-Z0-9]+\\.)+[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,5})?(/([!-~]|[\u2E80-\u9FFF]+)*)?"

#define regex_phonenum @"\\d{3,}"
#define regex_emoji @"[\\uE000-\\uF8FF]|\\uD83C[\\uDF00-\\uDFFF]|\\uD83D[\\uDC00-\\uDDFF]"



@interface FTCoreTextCommon : NSObject
{
    NSMutableDictionary *rangeDic;
    NSRegularExpression *httpRegular;
    NSRegularExpression *numberRegular;
    NSRegularExpression *emojiRegular;
}
singleton_h(FTCoreTextCommon);
//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(FTCoreTextCommon);

- (NSString *)getDrawTextByNormalText:(NSString *)normalText;
- (NSArray *)getCoreTextStyle;
- (NSArray *)getCorePureTextStyle;


- (NSArray *)getCoreTextStyleWithFont:(UIFont*)font color:(UIColor*)color ;
- (NSArray *)getSocialTopicCoreTextStyle;

//为了满足纯数字不带下划线的需求
- (NSArray *)getSocialTopicCoreTextStyleWithNormalText:(NSString *)normalText;

@end
