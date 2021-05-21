//
//  AzeroLogger.m
//  AzeroSDKWrapper
//
//  Created by nero on 2020/2/25.
//  Copyright © 2020 nero. All rights reserved.
//

#import "AzeroLogger.h"

class LoggerWrapper : public aace::logger::Logger {
public:
    LoggerWrapper(AzeroLogger *imp)
    : w (imp) {};
    
    bool logEvent(AzeroLoggerLevel level, std::chrono::system_clock::time_point time, const std::string& source, const std::string& message ) override {
        time_t t= std::chrono::system_clock::to_time_t(time);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
        
        return [w logEvent:[[NSString alloc] initWithUTF8String:message.c_str()] FromSrc:[[NSString alloc] initWithUTF8String:source.c_str()] OnLevel:level AtDate:date];
    }
private:
    __weak AzeroLogger *w;
};


@implementation AzeroLogger
{
    std::shared_ptr<aace::logger::Logger> wrapper;
}

-(AzeroLogger *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<LoggerWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(AzeroLoggerLevel) convertLevel:(AppLoggerLevel)level {
    AzeroLoggerLevel lel;
    switch (level) {
        case VERBOSE:
            lel = AzeroLoggerLevel::VERBOSE;
            break;
        case INFO:
            lel = AzeroLoggerLevel::INFO;
            break;
        case METRIC:
            lel = AzeroLoggerLevel::METRIC;
            break;
        case WARN:
            lel = AzeroLoggerLevel::WARN;
            break;
        case ERROR:
            lel = AzeroLoggerLevel::ERROR;
            break;
        case CRITICAL:
            lel = AzeroLoggerLevel::CRITICAL;
            break;
        default:
            lel = AzeroLoggerLevel::CRITICAL;
            break;
    }
    return lel;
}

-(void) log:(AppLoggerLevel)level withTag:(NSString *)tag  withMessage:(NSString *)message {
    AzeroLoggerLevel lvl = [self convertLevel:level];
    std::string tg = [tag cStringUsingEncoding:NSUTF8StringEncoding];
    std::string msg = [message cStringUsingEncoding:NSUTF8StringEncoding];
    wrapper->log(lvl,tg,msg);
    return;
}

@end
