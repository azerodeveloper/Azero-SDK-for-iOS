//
//  MyLocalDetectorEventHandler.h
//  test000
//
//  Created by silk on 2020/3/23.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroLocalSpeechDetectorEventHandler.h"
typedef void(^localDetectorEventSpeechStartBlock)(void);
typedef void(^localDetectorEventSpeechStopBlock)(void);
@interface MyLocalDetectorEventHandler : AzeroLocalSpeechDetectorEventHandler
- (void)localDetectorEventSpeechStartDetected:(localDetectorEventSpeechStartBlock )speechStartBlock;
- (void)localDetectorEventSpeechStopDetected:(localDetectorEventSpeechStopBlock )speechStopBlock;
@end

