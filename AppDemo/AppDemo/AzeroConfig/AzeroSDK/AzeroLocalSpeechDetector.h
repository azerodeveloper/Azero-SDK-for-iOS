//
//  AzeroLocalSpeechDetector.h
//  test000
//
//  Created by nero on 2020/3/20.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#import "AzeroLocalSpeechDetectorEventHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface AzeroLocalSpeechDetector : AzeroPlatformInterface

-(AzeroLocalSpeechDetector *) initWithEventHandler:(AzeroLocalSpeechDetectorEventHandler *)handler;
-(std::shared_ptr<aace::alexa::SpeechRecognizer>) getSpeechRecognizerHandler;

@end

NS_ASSUME_NONNULL_END
