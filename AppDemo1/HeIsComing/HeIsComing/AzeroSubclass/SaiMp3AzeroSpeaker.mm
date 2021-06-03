//
//  SaiMp3AzeroSpeaker.m
//  HeIsComing
//
//  Created by silk on 2020/5/19.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiMp3AzeroSpeaker.h"
@interface SaiMp3AzeroSpeaker ()
@end
@implementation SaiMp3AzeroSpeaker
//virtual
-(bool) setVolume:(int8_t)volume{
    dispatch_async(dispatch_get_main_queue(), ^{

        float volumeNum = (float)volume;
        if ((int)volumeNum!=[SaiAzeroManager sharedAzeroManager].volumeNum) {
                 [[SaiAzeroManager sharedAzeroManager] settedSystemCurrentVolume:volumeNum];
                     [kPlayer setVolumeNum:volumeNum];
            TYLog(@"设置音量 setVolume------------ %d",volume);

           }
//        [[SaiAzeroManager sharedAzeroManager] settedSystemCurrentVolume:volumeNum];
//        [kPlayer setVolumeNum:volumeNum];
    });
    return YES;
}
//virtual
-(bool) adjustVolume:(int8_t)delta{
    return YES;
}
//virtual
-(bool) setMute:(bool)mute{
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
