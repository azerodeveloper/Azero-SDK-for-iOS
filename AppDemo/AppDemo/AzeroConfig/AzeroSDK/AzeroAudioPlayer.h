//
//  AzeroAudioPlayer.h
//  test000
//
//  Created by nero on 2020/3/2.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAudioChannel.h"
#include <AACE/Alexa/AudioPlayer.h>

using AzeroAudioPlayerPlayerActivity = aace::alexa::AudioPlayer::PlayerActivity;

NS_ASSUME_NONNULL_BEGIN

@interface AzeroAudioPlayer : AzeroAudioChannel

//virtual
-(void) playerActivityChanged:(AzeroAudioPlayerPlayerActivity) state;

-(AzeroAudioPlayer *) initWithMediaPlayer:(AzeroMediaPlayer *)player andSpeaker:(AzeroSpeaker *)speaker;
@end

NS_ASSUME_NONNULL_END
