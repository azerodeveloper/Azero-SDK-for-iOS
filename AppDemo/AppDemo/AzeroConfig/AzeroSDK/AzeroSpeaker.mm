//
//  AzeroSpeaker.m
//  test000
//
//  Created by nero on 2020/2/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroSpeaker.h"

class SpeakerWrapper : public aace::alexa::Speaker {
public:
    SpeakerWrapper(AzeroSpeaker *imp)
    : w (imp) {};

    bool setVolume( int8_t volume ) override {
        return [w setVolume:volume];
    }
    
    bool adjustVolume( int8_t delta ) override {
        return [w adjustVolume:delta];
    }

    bool setMute( bool mute ) override {
        return [w setMute:mute];
    }

    int8_t getVolume() override {
        return [w getVolume];
    }

    bool isMuted() override {
        return [w isMuted];
    }
    
private:
    __weak AzeroSpeaker *w;
};

@implementation AzeroSpeaker
{
    std::shared_ptr<aace::alexa::Speaker> wrapper;
}

-(AzeroSpeaker *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<SpeakerWrapper>(self);
    }
    return self;
}

-(AzeroSpeaker *) initWithRawPtr:(std::shared_ptr<aace::alexa::Speaker>)ptr {
    if (self = [super init]) {
        wrapper = ptr;
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::alexa::Speaker>) getRawPtr {
    return wrapper;
}

-(void) localVolumeSet:(int8_t)volume {
    wrapper->localVolumeSet(volume);
}

-(void) localMuteSet:(bool)mute {
    wrapper->localMuteSet(mute);
}

@end
