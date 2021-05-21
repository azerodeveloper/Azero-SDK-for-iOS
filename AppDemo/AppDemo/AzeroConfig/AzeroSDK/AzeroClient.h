//
//  AzeroClient.h
//  HeIsComing
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroPlatformInterface.h"
#include <AACE/Alexa/AlexaClient.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroClient : AzeroPlatformInterface

//virtual
-(void) dialogStateChangedWithState:(aace::alexa::AlexaClient::DialogState) state;
//virtual
-(void) authStateChangedWithState:(aace::alexa::AlexaClient::AuthState) state andError:(aace::alexa::AlexaClient::AuthError) error;
//virtual
-(void) connectionStatusChangedWithStatus:(aace::alexa::AlexaClient::ConnectionStatus) status andReason:(aace::alexa::AlexaClient::ConnectionChangedReason) reason;

@end

NS_ASSUME_NONNULL_END
