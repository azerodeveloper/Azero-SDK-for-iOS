//
//  AzeroSpeechRecognizer.m
//  test000
//
//  Created by nero on 2020/3/2.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroSpeechRecognizer.h"

class SpeechRecognizerWrapper : public aace::alexa::SpeechRecognizer {
public:
    SpeechRecognizerWrapper(AzeroSpeechRecognizer *imp)
    :SpeechRecognizer(false)
    ,w (imp) {};
    
    bool wakewordDetected( const std::string& wakeword ) override {
        return [w wakewordDetected:[[NSString alloc] initWithUTF8String:wakeword.c_str()]];
    }

    void endOfSpeechDetected() override {
        [w endOfSpeechDetected];
    }

    bool startAudioInput() override {
        return [w startAudioInput];
    }

    bool stopAudioInput() override {
        return [w stopAudioInput];
    }
    
private:
    __weak AzeroSpeechRecognizer *w;
};

@implementation AzeroSpeechRecognizer
{
    std::shared_ptr<aace::alexa::SpeechRecognizer> wrapper;
}

-(AzeroSpeechRecognizer *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<SpeechRecognizerWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

+(uint64_t) UNSPECIFIED_INDEX {
    return aace::alexa::SpeechRecognizer::UNSPECIFIED_INDEX;
}

-(bool) holdToTalk {
    return wrapper->holdToTalk();
}

-(bool) tapToTalk {
    return wrapper->tapToTalk();
}

-(bool) startCapture:(AzeroSpeechRecognizerInitiator)initator withKeyWord:(NSString *)keyword BeginAt:(uint64_t)keywordBegin andEndAt:(uint64_t)keywordEnd {
    std::string sKeyword = [keyword cStringUsingEncoding:NSUTF8StringEncoding];
    return wrapper->startCapture(initator, keywordBegin, keywordEnd, sKeyword);
}

-(bool) stopCapture {
    return wrapper->stopCapture();
}

-(ssize_t) writeData:(const int16_t *)data withSize:(size_t)size {
    return wrapper->write(data, size);
}

-(bool) enableWakewordDetection {
    return wrapper->enableWakewordDetection();
}

-(bool) disableWakewordDetection {
    return wrapper->disableWakewordDetection();
}

-(NSString *) getCurrentDialogRequestId {
    return [[NSString alloc] initWithUTF8String:wrapper->getCurrentDialogRequestId().c_str()];
}

-(NSString *) getMessageRequestStatus {
    return [[NSString alloc] initWithUTF8String:wrapper->getMessageRequestStatus().c_str()];
}

-(bool) ClearDirectiveProcessId {
    return wrapper->ClearDirectiveProcessId();
}

-(bool) isWakewordDetectionEnabled {
    return wrapper->isWakewordDetectionEnabled();
}

@end
