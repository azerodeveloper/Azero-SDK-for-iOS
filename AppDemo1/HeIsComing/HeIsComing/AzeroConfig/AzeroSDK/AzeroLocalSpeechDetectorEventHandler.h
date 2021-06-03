//
//  AzeroLocalSpeechDetectorEventHandler.h
//  test000
//
//  Created by nero on 2020/3/20.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "cpp/LocalSpeechDetectorHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface AzeroLocalSpeechDetectorEventHandler : NSObject

-(std::shared_ptr<azeroSDK::LocalSpeechDetectorHandler::LocalSpeechDetectorEventInterface>) getRawPtr;

//virtual
// should return ASAP
-(void) onWakeWordDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andAngle:(float)angle;
//virtual
// should return ASAP
-(void) onSpeechStartTimeoutWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId;
//virtual
// should return ASAP
-(void) onSpeechStartDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId;
//virtual
// should return ASAP
-(void) onSpeechStopDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId;
//virtual
// should return ASAP
-(void) onAudioQueryErrorWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andErrorCode:(aace::openDenoise::LocalSpeechDetector::AudioQueryError) errc;
//virtual
// should return ASAP
-(void) onAudioQueryStartWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andResult:(bool)success;
//virtual
// should return ASAP
-(void) onAudioQueryStopWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId;

@end

NS_ASSUME_NONNULL_END
