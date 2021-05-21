//
//  SaiAzeroClient.m
//  HeIsComing
//
//  Created by silk on 2020/5/13.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiAzeroClient.h"
@interface SaiAzeroClient ()
@property (nonatomic ,copy)  saiAzeroClientBlock azeroClientHandle;
@end
@implementation SaiAzeroClient
//virtual
-(void) dialogStateChangedWithState:(aace::alexa::AlexaClient::DialogState) state{
    TYLog(@"dialogStateChangedWithState : %d   ",state);
}
//virtual
-(void) authStateChangedWithState:(aace::alexa::AlexaClient::AuthState) state andError:(aace::alexa::AlexaClient::AuthError) error{
    TYLog(@"authStateChangedWithState : %d   error : %d",state,error);
}
-(void) connectionStatusChangedWithStatus:(aace::alexa::AlexaClient::ConnectionStatus) status andReason:(aace::alexa::AlexaClient::ConnectionChangedReason) reason{
    switch (status) {
        case aace::alexa::AlexaClient::ConnectionStatus::DISCONNECTED:
            
            if (self.azeroClientHandle) {
                self.azeroClientHandle(NetworkTypeDISCONNECTED);
            }
            break;
        case aace::alexa::AlexaClient::ConnectionStatus::CONNECTED:
//            TYLog(@"与SDK建立连接%d",reason);
        {
            if (self.azeroClientHandle) {
                self.azeroClientHandle(NetworkTypeCONNECTED);
            }
            
        }
            break;
        case aace::alexa::AlexaClient::ConnectionStatus::PENDING:
        {   TYLog(@"与SDK断开连接%d",reason);
            
            if (self.azeroClientHandle) {
                self.azeroClientHandle(NetworkTypePENDING);
            }}
            break;
        default:
            break;
    }
}

- (void)saiAzeroClientConnectionStatusChangedWithStatus:(saiAzeroClientBlock )clientBlcok{
    if(clientBlcok){
        self.azeroClientHandle = clientBlcok;
    }
}
@end
