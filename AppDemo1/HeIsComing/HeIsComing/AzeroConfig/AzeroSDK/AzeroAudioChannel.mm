//
//  AzeroAudioChannel.m
//  test000
//
//  Created by nero on 2020/2/28.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "AzeroAudioChannel.h"

@implementation AzeroAudioChannel
-(AzeroMediaPlayer *) getMediaPlayer {
    return [[AzeroMediaPlayer alloc] initWithRawPtr:[self getAudioChannelRawPtr]->getMediaPlayer()];
}

-(AzeroSpeaker *) getSpeaker {
    return [[AzeroSpeaker alloc] initWithRawPtr:[self getAudioChannelRawPtr]->getSpeaker()];
}

-(AzeroSpeakerType) getSpeakerType {
    return [self getAudioChannelRawPtr]->getSpeakerType();
}
@end
