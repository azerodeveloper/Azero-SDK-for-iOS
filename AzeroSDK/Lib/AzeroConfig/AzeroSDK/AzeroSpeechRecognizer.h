//
//  AzeroSpeechRecognizer.h
//  test000
//
//  Created by nero on 2020/3/2.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Alexa/SpeechRecognizer.h>

using AzeroSpeechRecognizerInitiator = aace::alexa::SpeechRecognizer::Initiator;

NS_ASSUME_NONNULL_BEGIN

@interface AzeroSpeechRecognizer : AzeroPlatformInterface

//virtual
-(bool) wakewordDetected:(NSString *)wakeword;
//virtual
-(void) endOfSpeechDetected;
//virtual
-(bool) startAudioInput;
//virtual
-(bool) stopAudioInput;

+(uint64_t) UNSPECIFIED_INDEX;

-(bool) holdToTalk;
-(bool) tapToTalk;
-(bool) startCapture:(AzeroSpeechRecognizerInitiator)initator withKeyWord:(NSString *)keyword BeginAt:(uint64_t)keywordBegin andEndAt:(uint64_t)keywordEnd;
-(bool) stopCapture;
-(ssize_t) writeData:(const int16_t *)data withSize:(size_t)size;
-(bool) enableWakewordDetection;
-(bool) disableWakewordDetection;
-(NSString *) getCurrentDialogRequestId;
-(NSString *) getMessageRequestStatus;
-(bool) ClearDirectiveProcessId;
-(bool) isWakewordDetectionEnabled;
@end

NS_ASSUME_NONNULL_END
