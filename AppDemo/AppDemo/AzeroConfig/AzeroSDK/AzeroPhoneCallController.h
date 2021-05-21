//
//  AzeroPhoneCallController.h
//  HeIsComing
//
//  Created by nero on 2020/4/22.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/PhoneCallController/PhoneCallController.h>

struct AzeroPhoneCallControllerDeviceConfigurationItem {
    aace::phoneCallController::PhoneCallController::CallingDeviceConfigurationProperty property;
    bool enable;
};

NS_ASSUME_NONNULL_BEGIN

@interface AzeroPhoneCallController : AzeroPlatformInterface

//virtual
-(bool) dial:(NSString *)payload;
//virtual
-(bool) redial:(NSString *)payload;
//virtual
-(void) answer:(NSString *)payload;
//virtual
-(void) stop:(NSString *)payload;
//virtual
-(void) sendDTMF:(NSString *)payload;

-(void) connectionStateChanged:(aace::phoneCallController::PhoneCallController::ConnectionState)state;
-(void) callStateChanged:(aace::phoneCallController::PhoneCallController::CallState) state withCallId:(NSString *)callId andCallerId:(NSString *)callerId;
-(void) callFailedWithCallId:(NSString *)callId callError:(aace::phoneCallController::PhoneCallController::CallError)code andMessage:(NSString *)message;
-(void) callerIdReceivedWithCallId:(NSString *)callId andCallerId:(NSString *)callerId;
-(void) sendDTMFSucceededWithCallId:(NSString *)callId;
-(void) sendDTMFFailedWithCallId:(NSString *)callId DTMFError:(aace::phoneCallController::PhoneCallController::DTMFError)code andMessage:(NSString *)message;
-(void) deviceConfigurationUpdatedWithItems:(const AzeroPhoneCallControllerDeviceConfigurationItem *)items andSize:(size_t) len;
-(NSString *) createCallId;

@end

NS_ASSUME_NONNULL_END
