//
//  MyLocalDetectorEventHandler.m
//  test000
//
//  Created by silk on 2020/3/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MyLocalDetectorEventHandler.h"
@interface MyLocalDetectorEventHandler ()
@property (nonatomic ,copy)  localDetectorEventSpeechStartBlock eventSpeechStartHandle;
@property (nonatomic ,copy) localDetectorEventSpeechStopBlock eventSpeechStopHandle;
@end
@implementation MyLocalDetectorEventHandler
//virtual
// should return ASAP
-(void) onWakeWordDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andAngle:(float)angle{
}
//virtual
// should return ASAP
-(void) onSpeechStartTimeoutWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId{
}
//virtual
// vad start
-(void) onSpeechStartDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId{
    if (self.eventSpeechStartHandle) {
        self.eventSpeechStartHandle();
    }
}
//virtual
// vad end
-(void) onSpeechStopDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId{
    if (self.eventSpeechStopHandle) {
        self.eventSpeechStopHandle();
    }
}
//virtual
// should return ASAP
-(void) onAudioQueryErrorWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andErrorCode:(aace::openDenoise::LocalSpeechDetector::AudioQueryError) errc{
}
//virtual
// should return ASAP
-(void) onAudioQueryStartWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andResult:(bool)success{
}
//virtual
// should return ASAP
-(void) onAudioQueryStopWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId{
}
- (void)localDetectorEventSpeechStartDetected:(localDetectorEventSpeechStartBlock )speechStartBlock{
    if (speechStartBlock) {
        self.eventSpeechStartHandle = speechStartBlock;
    }
}
- (void)localDetectorEventSpeechStopDetected:(localDetectorEventSpeechStopBlock )speechStopBlock{
    if (speechStopBlock) {
        self.eventSpeechStopHandle = speechStopBlock;
    }
}
@end
