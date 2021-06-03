//
//  AzeroSpeechSynthesizer.m
//  test000
//
//  Created by nero on 2020/2/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroSpeechSynthesizer.h"
#include <AACE/Alexa/SpeechSynthesizer.h>

class SpeechSynthesizerWrapper : public aace::alexa::SpeechSynthesizer {
public:
    SpeechSynthesizerWrapper(
                AzeroSpeechSynthesizer *imp,
                std::shared_ptr<aace::alexa::MediaPlayer> mediaPlayer,
                std::shared_ptr<aace::alexa::Speaker> speaker)
    : aace::alexa::SpeechSynthesizer(mediaPlayer, speaker)
    , w (imp) {};
    
    void handlePrePlaybackStarted(void) override {
        [w handlePrePlaybackStarted];
    }
    void handlePostPlaybackFinished(void) override {
        [w handlePostPlaybackFinished];
    };
    
private:
    __weak AzeroSpeechSynthesizer *w;
};

@implementation AzeroSpeechSynthesizer
{
    std::shared_ptr<aace::alexa::SpeechSynthesizer> wrapper;
}

-(AzeroSpeechSynthesizer *) init {
    assert(false);
    return NULL;
}

-(AzeroSpeechSynthesizer *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker {
    if (self = [super init]) {
        wrapper = std::make_shared<SpeechSynthesizerWrapper>(
                                        self, [player getRawPtr], [speaker getRawPtr]);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr; {
    return wrapper;
}

-(std::shared_ptr<aace::alexa::AudioChannel>) getAudioChannelRawPtr {
    return wrapper;
}

-(void) handlePrePlaybackStarted {}
-(void) handlePostPlaybackFinished {}

@end
