//
//  NSDate+Extension.h
//  Sekey
//
//  Created by silk on 2017/4/1.
//  Copyright © 2017年 silk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (Extension)
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;

/**
 *  判断两个时间戳是否为同一天
 */
+ (BOOL)isDate:(long long)dateNumber1 inSameDayAsDate:(long long)dateNumber2;

/**
 *  当天零点的时间戳
 */
+ (NSDate *)zeroOfDate;

/**
 *  获取当前的时间戳
 */
+ (NSString *)timeStamp;


@end
