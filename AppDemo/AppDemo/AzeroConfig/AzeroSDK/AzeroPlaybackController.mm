//
//  AzeroPlaybackController.m
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlaybackController.h"

class PlaybackControllerWrapper : public aace::alexa::PlaybackController {
public:
    PlaybackControllerWrapper(AzeroPlaybackController *imp)
    : w (imp) {};
    
private:
    __weak AzeroPlaybackController *w;
};


@implementation AzeroPlaybackController
{
    std::shared_ptr<aace::alexa::PlaybackController> wrapper;
}

-(AzeroPlaybackController *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<PlaybackControllerWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(void) buttonPressed:(aace::alexa::PlaybackController::PlaybackButton) button {
    wrapper->buttonPressed( button );
}

-(void) togglePressed:(aace::alexa::PlaybackController::PlaybackToggle) toggle withAction:(bool) action {
    wrapper->togglePressed( toggle, action );
}

@end
