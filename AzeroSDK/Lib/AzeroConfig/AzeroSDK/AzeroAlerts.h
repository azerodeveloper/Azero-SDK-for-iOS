//
//  AzeroAlerts.h
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAudioChannel.h"
#include <AACE/Alexa/Alerts.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroAlerts : AzeroAudioChannel

//virtual
-(void) alertStateChangedWithToken:(NSString *) alertToken state:(aace::alexa::Alerts::AlertState) state andReason:(NSString *) reason;
//virtual
-(void) alertCreatedWithToken:(NSString *) alertToken andDetailInfo:(NSString *) detailedInfo;
//virtual
-(void) alertDeletedWithToken:(NSString *) alertToken;

-(void) localStop;
-(void) removeAllAlerts;
-(void) removeAlert:(NSString *) alertToken;

-(AzeroAlerts *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker;

@end

NS_ASSUME_NONNULL_END
