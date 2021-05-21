//
//  AzeroModeObserver.m
//  test000
//
//  Created by nero on 2020/4/10.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroModeObserver.h"

class ModeObserverWrapper : public aace::openDenoise::ModeObserver {
public:
    ModeObserverWrapper(AzeroModeObserver *imp)
    : w (imp) {};

    bool onModeChangePrepare( const ModeConfiguration &config ) override {
        return [w onModeChangePrepare:config];
    }

    void onModeChangeCancelled( const ModeConfiguration &config ) override {
        [w onModeChangeCancelled:config];
    }

    void onChangeMode( const ModeConfiguration &config ) override {
        [w onChangeMode:config];
    }

    void onModeChanged( const ModeConfiguration &config ) override {
        [w onModeChanged:config];
    }

    void onModeChangeFailed() override {
        [w onModeChangeFailed];
    }

    void onModeSystemShutDown() override {
        [w onModeSystemShutDown];
    }

    void onModeExecutionException() override {
        [w onModeExecutionException];
    }
    
private:
    __weak AzeroModeObserver *w;
};


@implementation AzeroModeObserver
{
    std::shared_ptr<aace::openDenoise::ModeObserver> wrapper;
}

-(AzeroModeObserver *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<ModeObserverWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(bool) onModeChangePrepare:(const aace::openDenoise::ModeObserverInterface::ModeConfiguration &)config {
    return true;
}

-(void) onModeChangeCancelled:(const aace::openDenoise::ModeObserverInterface::ModeConfiguration &)config {}

-(void) onChangeMode:(const aace::openDenoise::ModeObserverInterface::ModeConfiguration &)config {}

-(void) onModeChanged:(const aace::openDenoise::ModeObserverInterface::ModeConfiguration &)config {}

-(void) onModeChangeFailed {}

-(void) onModeSystemShutDown {}

-(void) onModeExecutionException {}

@end
