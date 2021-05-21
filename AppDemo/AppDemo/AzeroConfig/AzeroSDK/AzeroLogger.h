//
//  AzeroLogger.h
//  AzeroSDKWrapper
//
//  Created by nero on 2020/2/25.
//  Copyright © 2020 nero. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Logger/Logger.h>

using AzeroLoggerLevel = aace::logger::Logger::Level;

typedef NS_ENUM(NSUInteger, AppLoggerLevel) {
    VERBOSE,
    INFO,
    METRIC,
    WARN,
    ERROR,
    CRITICAL
};

NS_ASSUME_NONNULL_BEGIN

@interface AzeroLogger : AzeroPlatformInterface
-(AzeroLoggerLevel) convertLevel:(AppLoggerLevel)level;
-(void) log:(AppLoggerLevel)level withTag:(NSString *)tag  withMessage:(NSString *)message;
//virtual
-(bool) logEvent:(NSString *)src FromSrc:(NSString *)msg OnLevel:(AzeroLoggerLevel) level AtDate:(NSDate *) date;
@end

NS_ASSUME_NONNULL_END
