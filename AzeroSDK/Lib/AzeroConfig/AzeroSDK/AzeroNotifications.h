//
//  AzeroNotifications.h
//  AzeroDemo
//
//  Created by nero on 2020/4/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAudioChannel.h"

#include <AACE/Alexa/Notifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface AzeroNotifications : AzeroAudioChannel

//virtual
-(void) setIndicator:(aace::alexa::Notifications::IndicatorState) state;

-(AzeroNotifications *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker;

@end

NS_ASSUME_NONNULL_END
