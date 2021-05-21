//
//  SaiTtsAzeroSpeaker.m
//  AzeroDemo
//
//  Created by silk on 2020/5/19.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiTtsAzeroSpeaker.h"
#import <MediaPlayer/MediaPlayer.h>
@interface SaiTtsAzeroSpeaker ()

@end
@implementation SaiTtsAzeroSpeaker
//virtual
-(bool) setVolume:(int8_t)volume{
    //在此处设置音量
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
    //获取播放器的音量大小并上报
    return 0;
}

-(bool) isMuted{
    return false;
}

@end
