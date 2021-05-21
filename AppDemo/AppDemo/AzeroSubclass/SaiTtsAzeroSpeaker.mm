//
//  SaiTtsAzeroSpeaker.m
//  HeIsComing
//
//  Created by silk on 2020/5/19.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiTtsAzeroSpeaker.h"
#import "GKVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface SaiTtsAzeroSpeaker ()

@end
@implementation SaiTtsAzeroSpeaker
//virtual
-(bool) setVolume:(int8_t)volume{
    dispatch_async(dispatch_get_main_queue(), ^{
        float volumeNum = (float)volume;
        if ((int)volumeNum!=[SaiAzeroManager sharedAzeroManager].volumeNum) {
              [[SaiAzeroManager sharedAzeroManager] settedSystemCurrentVolume:volumeNum];
                  [kPlayer setVolumeNum:volumeNum];
            TYLog(@"设置音量 setVolume------------ %d",volume);
        }
    });
    return YES;
}
//virtual
-(bool) adjustVolume:(int8_t)delta{
    TYLog(@"设置音量 adjustVolume ------------ %d",delta);
    return YES;
}
//virtual  
-(bool) setMute:(bool)mute{
    TYLog(@"设置静音setMute ------------ %d",mute);
    return YES;
}
-(int8_t) getVolume{
    float value = [[AVAudioSession sharedInstance] outputVolume];
    return (char)((int )value & 0xff);
}

-(bool) isMuted{
    return false;
}

@end
