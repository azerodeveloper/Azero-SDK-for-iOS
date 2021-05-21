//
//  AzeroNotifications.m
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroNotifications.h"

class NotificationsWrapper : public aace::alexa::Notifications {
public:
    NotificationsWrapper(AzeroNotifications *imp,
    std::shared_ptr<aace::alexa::MediaPlayer> mediaPlayer,
    std::shared_ptr<aace::alexa::Speaker> speaker)
    : aace::alexa::Notifications(mediaPlayer, speaker)
    , w (imp) {};
    
    void setIndicator( IndicatorState state ) {
        [w setIndicator:state];
    }
    
private:
    __weak AzeroNotifications *w;
};


@implementation AzeroNotifications
{
    std::shared_ptr<aace::alexa::Notifications> wrapper;
}

-(AzeroNotifications *) init {
    assert(false);
    return NULL;
}

-(AzeroNotifications *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker {
    if (self = [super init]) {
        wrapper = std::make_shared<NotificationsWrapper>(
                                        self, [player getRawPtr], [speaker getRawPtr]);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(std::shared_ptr<aace::alexa::AudioChannel>) getAudioChannelRawPtr {
    return wrapper;
}

@end
