//
//  AzeroAudioChannel.h
//  test000
//
//  Created by nero on 2020/2/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AACE/Alexa/AudioChannel.h>
#import "AzeroMediaPlayer.h"
#import "AzeroSpeaker.h"
#import "AzeroPlatformInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface AzeroAudioChannel : AzeroPlatformInterface

//virtual
-(std::shared_ptr<aace::alexa::AudioChannel>) getAudioChannelRawPtr;

-(AzeroMediaPlayer *) getMediaPlayer;
-(AzeroSpeaker *) getSpeaker;
-(AzeroSpeakerType) getSpeakerType;
@end

NS_ASSUME_NONNULL_END
