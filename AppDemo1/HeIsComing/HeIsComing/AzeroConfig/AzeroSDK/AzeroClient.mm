//
//  AzeroClient.m
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroClient.h"

class AlexaClientWrapper : public aace::alexa::AlexaClient {
public:
    AlexaClientWrapper(AzeroClient *imp)
    : w (imp) {};
    
    void dialogStateChanged( DialogState state ) override {
        [w dialogStateChangedWithState:state];
    }
    
    void authStateChanged( AuthState state, AuthError error ) override {
        [w authStateChangedWithState:state andError:error];
    }
    
    void connectionStatusChanged( ConnectionStatus status, ConnectionChangedReason reason ) {
        [w connectionStatusChangedWithStatus:status andReason:reason];
    }
    
private:
    __weak AzeroClient *w;
};


@implementation AzeroClient
{
    std::shared_ptr<aace::alexa::AlexaClient> wrapper;
}

-(AzeroClient *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<AlexaClientWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(void) dialogStateChangedWithState:(aace::alexa::AlexaClient::DialogState) state {
}

-(void) authStateChangedWithState:(aace::alexa::AlexaClient::AuthState) state andAuthError:(aace::alexa::AlexaClient::AuthError) error {
    
}

-(void) connectionStatusChangedWithStatus:(aace::alexa::AlexaClient::ConnectionStatus) status andConnectionChangeReason:(aace::alexa::AlexaClient::ConnectionChangedReason) reason {
}


@end
