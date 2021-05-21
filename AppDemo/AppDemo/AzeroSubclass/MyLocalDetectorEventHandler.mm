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
    TYLog(@"onWakeWordDetectedWithTag--------tag:%d --- sequenceId：%llu --- angle:%ff",tag,sequenceId,angle);
}
//virtual
// should return ASAP
-(void) onSpeechStartTimeoutWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId{
    TYLog(@"onSpeechStartTimeoutWithTag--------tag:%d --- sequenceId：%llu ",tag,sequenceId);
}
//virtual
// should return ASAP
-(void) onSpeechStartDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId{
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.eventSpeechStartHandle) {
            self.eventSpeechStartHandle();
        }
//    });
    TYLog(@"onSpeechStartDetectedWithTag--------tag:%d --- sequenceId：%llu ",tag,sequenceId);
}
//virtual
// should return ASAP
-(void) onSpeechStopDetectedWithTag:(int)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId{
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.eventSpeechStopHandle) {
            self.eventSpeechStopHandle();
            TYLog(@"--**localDetectorEventSpeechStopDetected1");

        }
//    });
    TYLog(@"--**localDetectorEventSpeechStopDetected0");

    TYLog(@"onSpeechStopDetectedWithTag--------tag:%d --- sequenceId：%llu ",tag,sequenceId);
}
//virtual
// should return ASAP
-(void) onAudioQueryErrorWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andErrorCode:(aace::openDenoise::LocalSpeechDetector::AudioQueryError) errc{
    TYLog(@"onAudioQueryErrorWithSequenceId--------sequenceId:%llu --- errc：%d ",sequenceId,errc);
}
//virtual
// should return ASAP
-(void) onAudioQueryStartWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andResult:(bool)success{
    TYLog(@"onAudioQueryStartWithSequenceId--------sequenceId:%llu --- errc：%d ",sequenceId,success);
}
//virtual
// should return ASAP
-(void) onAudioQueryStopWithSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId{
    TYLog(@"onAudioQueryStopWithSequenceId--------sequenceId:%llu ",sequenceId);
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
