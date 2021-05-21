//
//  MyLogger.m
//  test000
//
//  Created by silk on 2020/3/3.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MyLogger.h"

@implementation MyLogger
-(bool) logEvent:(NSString *)msg FromSrc:(NSString *)src OnLevel:(AzeroLoggerLevel) level AtDate:(NSDate *) date {

//    TYLog(@"%@-%d-%@:%@", date, (int)level, src, msg);
    return true;
}
@end
