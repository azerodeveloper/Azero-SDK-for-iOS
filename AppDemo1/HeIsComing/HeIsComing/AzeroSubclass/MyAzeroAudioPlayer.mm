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
            TYLog(@"播放的状态 ：MyAudioPlayer****************************************************************IDLE------------------------");
            break;
        case aace::alexa::AudioPlayer::PlayerActivity::PLAYING:
            TYLog(@"播放的状态 ：MyAudioPlayer****************************************************************PLAYING------------------------");
            break;
        case aace::alexa::AudioPlayer::PlayerActivity::STOPPED:
            TYLog(@"播放的状态 ：MyAudioPlayer****************************************************************STOPPED------------------------");
            break;
        case aace::alexa::AudioPlayer::PlayerActivity::PAUSED:
            TYLog(@"播放的状态 ：MyAudioPlayer****************************************************************PAUSED------------------------");
            break;
        case aace::alexa::AudioPlayer::PlayerActivity::BUFFER_UNDERRUN:
            TYLog(@"播放的状态 ：MyAudioPlayer****************************************************************BUFFER_UNDERRUN------------------------");
           break;
        case aace::alexa::AudioPlayer::PlayerActivity::FINISHED:
            TYLog(@"播放的状态 ：MyAudioPlayer****************************************************************FINISHED------------------------");
        break;
        default:
            break;
    }
}
@end
