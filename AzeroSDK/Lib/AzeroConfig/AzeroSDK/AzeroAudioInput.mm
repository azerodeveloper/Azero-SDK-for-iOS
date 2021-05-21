//
//  AzeroAudioInput.m
//  test000
//
//  Created by nero on 2020/3/20.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAudioInput.h"
#include <AACE/OpenDenoise/AudioInput.h>

class AudioInputWrapper : public aace::openDenoise::AudioInput {
public:
    AudioInputWrapper(AzeroAudioInput *imp)
    : w (imp) {};

private:
    __weak AzeroAudioInput *w;
};

@implementation AzeroAudioInput
{
    std::shared_ptr<aace::openDenoise::AudioInput> wrapper;
}

-(AzeroAudioInput *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<AudioInputWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(bool) writeData:(const char *)data withSize:(size_t)size {
    return wrapper->write(data, size);
}

@end
