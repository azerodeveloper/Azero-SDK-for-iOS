//
//  AzeroAudioPlayer.m
//  test000
//
//  Created by nero on 2020/3/2.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAudioPlayer.h"

class AudioPlayerWrapper : public aace::alexa::AudioPlayer {
public:
    AudioPlayerWrapper(
                AzeroAudioPlayer *imp,
                std::shared_ptr<aace::alexa::MediaPlayer> mediaPlayer,
                std::shared_ptr<aace::alexa::Speaker> speaker)
    : aace::alexa::AudioPlayer(mediaPlayer, speaker)
    , w (imp) {};
    
    void playerActivityChanged(PlayerActivity state) override {
        [w playerActivityChanged:state];
    }
    
private:
    __weak AzeroAudioPlayer *w;
};

@implementation AzeroAudioPlayer
{
    std::shared_ptr<aace::alexa::AudioPlayer> wrapper;
}

-(AzeroAudioPlayer *) init {
    assert(false);
    return NULL;
}

-(AzeroAudioPlayer *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker {
    if (self = [super init]) {
        wrapper = std::make_shared<AudioPlayerWrapper>(
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

-(void) playerActivityChanged:(AzeroAudioPlayerPlayerActivity)state {}


@end
