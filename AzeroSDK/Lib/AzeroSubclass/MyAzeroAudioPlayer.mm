//
//  MyAzeroAudioPlayer.m
//  test000
//
//  Created by silk on 2020/3/6.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "MyAzeroAudioPlayer.h"

@implementation MyAzeroAudioPlayer
-(void) playerActivityChanged:(AzeroAudioPlayerPlayerActivity) state {
    switch (state) {
        case aace::alexa::AudioPlayer::PlayerActivity::IDLE:
            break;
        case aace::alexa::AudioPlayer::PlayerActivity::PLAYING:
            break;
        case aace::alexa::AudioPlayer::PlayerActivity::STOPPED:
            break;
        case aace::alexa::AudioPlayer::PlayerActivity::PAUSED:
            break;
        case aace::alexa::AudioPlayer::PlayerActivity::BUFFER_UNDERRUN:
           break;
        case aace::alexa::AudioPlayer::PlayerActivity::FINISHED:
        break;
        default:
            break;
    }
}
@end
