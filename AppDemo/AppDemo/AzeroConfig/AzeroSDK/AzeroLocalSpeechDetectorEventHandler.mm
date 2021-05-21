//
//  AzeroLocalSpeechDetectorEventHandler.m
//  test000
//
//  Created by nero on 2020/3/20.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroLocalSpeechDetectorEventHandler.h"


class LocalSpeechDectorEventHandlerWrapper :
    public azeroSDK::LocalSpeechDetectorHandler::LocalSpeechDetectorEventInterface {
public:
    LocalSpeechDectorEventHandlerWrapper(AzeroLocalSpeechDetectorEventHandler *imp)
    : w (imp) {};
    
    void onWakeWordDetected( int tag, SequenceIdType sequenceId, float angle ) override {
        [w onWakeWordDetectedWithTag:tag andSequenceId:sequenceId andAngle:angle];
    }
        
    void onSpeechStartTimeout( int tag, SequenceIdType sequenceId ) override {
        [w onSpeechStartTimeoutWithTag:tag andSequenceId:sequenceId];
    };
    void onSpeechStartDetected( int tag, SequenceIdType sequenceId ) override {
        [w onSpeechStartDetectedWithTag:tag andSequenceId:sequenceId];
    };
    void onSpeechStopDetected( int tag, SequenceIdType sequenceId ) override {
        [w onSpeechStopDetectedWithTag:tag andSequenceId:sequenceId];
    };

    void onAudioQueryError( SequenceIdType sequenceId, aace::openDenoise::LocalSpeechDetector::AudioQueryError err ) override {
        [w onAudioQueryErrorWithSequenceId:sequenceId andErrorCode:err];
    };
    void onAudioQueryStart( SequenceIdType sequenceId, bool success ) override {
        [w onAudioQueryStartWithSequenceId:sequenceId andResult:success];
    };
    void onAudioQueryStop( SequenceIdType sequenceId ) override {
        [w onAudioQueryStopWithSequenceId:sequenceId];
    };
private:
    __weak AzeroLocalSpeechDetectorEventHandler *w;
};

@implementation AzeroLocalSpeechDetectorEventHandler
{
    std::shared_ptr<azeroSDK::LocalSpeechDetectorHandler::LocalSpeechDetectorEventInterface> wrapper;
}

-(AzeroLocalSpeechDetectorEventHandler *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<LocalSpeechDectorEventHandlerWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<azeroSDK::LocalSpeechDetectorHandler::LocalSpeechDetectorEventInterface>) getRawPtr {
    return wrapper;
}

-(void) onWakeWordDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andAngle:(float)angle {
}

-(void) onSpeechStartTimeoutWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId {
}

-(void) onSpeechStartDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId {
}

-(void) onSpeechStopDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId {
}

-(void) onAudioQueryErrorWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andErrorCode:(aace::openDenoise::LocalSpeechDetector::AudioQueryError) errc {
}

-(void) onAudioQueryStartWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andResult:(bool)success {
}

-(void) onAudioQueryStopWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId {
}

@end
