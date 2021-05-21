//
//  AzeroMediaPlayer.m
//  test000
//
//  Created by nero on 2020/2/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroMediaPlayer.h"

class MediaPlayerWrapper : public aace::alexa::MediaPlayer {
public:
    MediaPlayerWrapper(AzeroMediaPlayer *imp)
    : w (imp) {};
    
    bool prepare() override {
        return [w prepare];
    }

    bool prepare( const std::string& url ) override {
        return [w prepareWithUrl:[[NSString alloc] initWithUTF8String:url.c_str()]];
    }

    bool play() override {
        return [w play];
    }

    bool stop() override {
        return [w stop];
    }

    bool pause() override {
        return [w pause];
    }

    bool resume() override {
        return [w resume];
    }

    int64_t getPosition() override {
        return [w getPosition];
    }

    bool setPosition( int64_t position ) override {
        return [w setPosition:position];
    }
    
private:
    __weak AzeroMediaPlayer *w;
};

@implementation AzeroMediaPlayer
{
    std::shared_ptr<aace::alexa::MediaPlayer> wrapper;
}

-(AzeroMediaPlayer *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<MediaPlayerWrapper>(self);
    }
    return self;
}

-(AzeroMediaPlayer *) initWithRawPtr:(std::shared_ptr<aace::alexa::MediaPlayer>)ptr {
    if (self = [super init]) {
        wrapper = ptr;
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::alexa::MediaPlayer>) getRawPtr {
    return wrapper;
}

-(bool) isRepeating {
    return wrapper->isRepeating();
}

-(void) mediaStateChanged:(AzeroMediaPlayerMediaState)state {
    wrapper->mediaStateChanged(state);
}

-(void) mediaError:(AzeroMediaPlayerMediaError)error {
    wrapper->mediaError(error);
}

-(void) mediaError:(AzeroMediaPlayerMediaError)error withDescription:(NSString *)description {
    std::string dsc = [description cStringUsingEncoding:NSUTF8StringEncoding];
    wrapper->mediaError(error, dsc);
}

-(ssize_t) readData:(char*) data withSize:(size_t) size {
    return wrapper->read(data, size);
}

-(bool) isClosed {
    return wrapper->isClosed();
}

@end
