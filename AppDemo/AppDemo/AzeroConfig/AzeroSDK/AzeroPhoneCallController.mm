//
//  AzeroPhoneCallController.m
//  HeIsComing
//
//  Created by nero on 2020/4/22.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPhoneCallController.h"

class PhoneCallControllerWrapper : public aace::phoneCallController::PhoneCallController {
public:
    PhoneCallControllerWrapper(AzeroPhoneCallController *imp)
    : w (imp) {};
    
    bool dial( const std::string& payload ) override {
        return [w dial:[[NSString alloc] initWithUTF8String:payload.c_str()]];
    }

    bool redial( const std::string& payload ) override {
        return [w redial:[[NSString alloc] initWithUTF8String:payload.c_str()]];
    }

    void answer( const std::string& payload ) override {
        return [w answer:[[NSString alloc] initWithUTF8String:payload.c_str()]];
    }

    void stop( const std::string& payload ) override {
        return [w stop:[[NSString alloc] initWithUTF8String:payload.c_str()]];
    }

    void sendDTMF( const std::string& payload ) override {
        return [w sendDTMF:[[NSString alloc] initWithUTF8String:payload.c_str()]];
    }
    
private:
    __weak AzeroPhoneCallController *w;
};


@implementation AzeroPhoneCallController
{
    std::shared_ptr<aace::phoneCallController::PhoneCallController> wrapper;
}

-(AzeroPhoneCallController *) init {
    if (self = [super init]) {
        wrapper = std::make_shared<PhoneCallControllerWrapper>(self);
    }
    return self;
}

-(void) dealloc {
    wrapper.reset();
}

-(std::shared_ptr<aace::core::PlatformInterface>) getPlatformInterfaceRawPtr {
    return wrapper;
}

-(void) connectionStateChanged:(aace::phoneCallController::PhoneCallController::ConnectionState)state {
    wrapper->connectionStateChanged( state );
}

-(void) callStateChanged:(aace::phoneCallController::PhoneCallController::CallState) state withCallId:(NSString *)callId andCallerId:(NSString *)callerId {
    std::string strCallId, strCallerId;
    strCallId = [callId cStringUsingEncoding:NSUTF8StringEncoding];

    if ( callerId ) {
        strCallerId = [callerId cStringUsingEncoding:NSUTF8StringEncoding];
    }
    wrapper->callStateChanged( state, strCallId, strCallerId );
}

-(void) callFailedWithCallId:(NSString *)callId callError:(aace::phoneCallController::PhoneCallController::CallError)code andMessage:(NSString *)message {
    std::string strCallId, strMessage;
    strCallId = [callId cStringUsingEncoding:NSUTF8StringEncoding];
    if ( message ) {
        strMessage = [message cStringUsingEncoding:NSUTF8StringEncoding];
    }
    wrapper->callFailed( strCallId, code, strMessage );
}

-(void) callerIdReceivedWithCallId:(NSString *)callId andCallerId:(NSString *)callerId {
    std::string strCallId, strCallerId;
    strCallId = [callId cStringUsingEncoding:NSUTF8StringEncoding];
    strCallerId = [callerId cStringUsingEncoding:NSUTF8StringEncoding];
    wrapper->callerIdReceived( strCallId, strCallerId );
}

-(void) sendDTMFSucceededWithCallId:(NSString *)callId {
    wrapper->sendDTMFSucceeded( [callId cStringUsingEncoding:NSUTF8StringEncoding] );
}

-(void) sendDTMFFailedWithCallId:(NSString *)callId DTMFError:(aace::phoneCallController::PhoneCallController::DTMFError)code andMessage:(NSString *)message {
    std::string strCallId, strMessage;
    strCallId = [callId cStringUsingEncoding:NSUTF8StringEncoding];
    if ( message ) {
        strMessage = [message cStringUsingEncoding:NSUTF8StringEncoding];
    }
    wrapper->sendDTMFFailed( strCallId, code, strMessage );
}

-(void) deviceConfigurationUpdatedWithItems:(const AzeroPhoneCallControllerDeviceConfigurationItem *)items andSize:(size_t) len {
    std::unordered_map<aace::phoneCallController::PhoneCallController::CallingDeviceConfigurationProperty, bool> configMap;
    if ( items ) {
        for ( size_t i = 0; i < len; ++i ) {
            configMap[items[i].property] = items[i].enable;
        }
    }
    wrapper->deviceConfigurationUpdated( configMap );
}

-(NSString *) createCallId {
    auto callId = wrapper->createCallId();
    return [[NSString alloc] initWithUTF8String:callId.c_str()];
}

@end
