//
//  AzeroLocalSpeechDetector.m
//  test000
//
//  Created by nero on 2020/3/20.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroLocalSpeechDetector.h"

@implementation AzeroLocalSpeechDetector
{
    std::shared_ptr<azeroSDK::LocalSpeechDetectorHandler> wrapper;
}

-(AzeroLocalSpeechDetector *) init {
    if (self = [super init]) {
        assert(false);
    }
    return self;
}

-(AzeroLocalSpeechDetector *) initWithEventHandler:(AzeroLocalSpeechDetectorEventHandler *)handler {
    if (self = [super init]) {
        wrapper = azeroSDK::LocalSpeechDetectorHandler::create([handler getRawPtr]);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(std::shared_ptr<aace::alexa::SpeechRecognizer>) getSpeechRecognizerHandler {
    return wrapper->getSpeechRecognizerHandler();
}

@end
