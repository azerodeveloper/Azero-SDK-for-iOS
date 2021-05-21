//
//  AzeroAlerts.m
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAlerts.h"

class AlertsWrapper : public aace::alexa::Alerts {
public:
    AlertsWrapper(
                AzeroAlerts *imp,
                std::shared_ptr<aace::alexa::MediaPlayer> mediaPlayer,
                std::shared_ptr<aace::alexa::Speaker> speaker)
    : aace::alexa::Alerts(mediaPlayer, speaker)
    , w (imp) {};
    
    void alertStateChanged( const std::string& alertToken, AlertState state, const std::string& reason ) override {
        [w alertStateChangedWithToken:[[NSString alloc] initWithUTF8String:alertToken.c_str()] state:state andReason:[[NSString alloc] initWithUTF8String:reason.c_str()]];
    }

    void alertCreated( const std::string& alertToken, const std::string& detailedInfo ) override {
        [w alertCreatedWithToken:[[NSString alloc] initWithUTF8String:alertToken.c_str()] andDetailInfo:[[NSString alloc] initWithUTF8String:detailedInfo.c_str()]];
    }

    void alertDeleted( const std::string& alertToken ) override {
        [w alertDeletedWithToken:[[NSString alloc] initWithUTF8String:alertToken.c_str()]];
    }
    
private:
    __weak AzeroAlerts *w;
};

@implementation AzeroAlerts
{
    std::shared_ptr<aace::alexa::Alerts> wrapper;
}

-(AzeroAlerts *) init {
    assert(false);
    return NULL;
}

-(AzeroAlerts *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker {
    if (self = [super init]) {
        wrapper = std::make_shared<AlertsWrapper>(
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

-(void) alertStateChangedWithToken:(NSString *) alertToken state:(aace::alexa::Alerts::AlertState) state andReason:(NSString *) reason {
}

-(void) alertCreatedWithToken:(NSString *) alertToken andDetailInfo:(NSString *) detailedInfo {
}

-(void) alertDeletedWithToken:(NSString *) alertToken {
}

-(void) localStop {
    wrapper->localStop();
}

-(void) removeAllAlerts {
    wrapper->removeAllAlerts();
}

-(void) removeAlert:(NSString *) alertToken {
    wrapper->removeAlert(std::string([alertToken cStringUsingEncoding:NSUTF8StringEncoding]));
}

@end
