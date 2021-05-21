//
//  MyLogger.h
//  test000
//
//  Created by silk on 2020/3/3.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLogger : AzeroLogger
-(bool) logEvent:(NSString *)msg FromSrc:(NSString *)src OnLevel:(AzeroLoggerLevel) level AtDate:(NSDate *) date;
@end

NS_ASSUME_NONNULL_END
